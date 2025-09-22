<?php
require 'vendor/autoload.php';

use Mpdf\Mpdf;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

class UserController
{
    private $db;
    public function __construct()
    {
      // Initialize the database connection
      $this->db = new mysqli('localhost', 'root', '', 'mummy_cabs_db1');
      //$this->db = new mysqli('localhost', 'u249479749_mummy', 'Mummycabs@123', 'u249479749_mummy_cabs_db');
    }

    public function handleRequest()
    {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, DELETE, PUT, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type');
        header('Content-Type: application/json');

        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $data = empty($_POST) ? json_decode(file_get_contents('php://input'), true) : $_POST;

            if (isset($data['service_id'])) {
                switch ($data['service_id']) {
                    case 'login':
                        $this->handleLogin($data);
                        break;
                    case 'register':
                        $this->handleRegister($data);
                        break;
                    case 'forgot_password':
                        $this->forgotPassword($data);
                        break;
                    case 'user_deactivate':
                        $this->userDeactivate($data);
                        break;
                    case 'drivers_list':
                        $this->driversList($data);
                        break;
                    case 'add_new_car':
                        $this->addNewCar($data);
                        break;
                    case 'car_deactive':
                        $this->carDeactivate ($data);
                        break;
                    case 'car_list':
                        $this->carList ($data);
                        break;
                    case 'trips_list':
                        $this->datewiseTripList ($data);
                        break;      
                    case 'new_trip':
                        $this->newTripaddFunction ($data);
                        break;
                    case 'edit_trip':
                        $this->editTripFunction ($data);
                        break;
                    case 'delete_trip':
                        $this-> deleteFunction($data);
                        break;    
                    case 'cart_amount_update':
                        $this->cartAmountUpdate ($data);
                        break;
                    case 'trip_list_driver':
                        $this->tripListLdriver ($data);
                        break;
                    case 'transaction_history':
                        $this->transactionHistory ($data);
                        break;
                    case 'new_customer':
                        $this->newCustomer($data);
                        break;
                    case 'customer_list':
                        $this->customerList($data);
                        break;    
                    case 'add_companytrip':
                        $this->companyTripaddFunction($data);
                        break;
                    case 'edit_companytrip':
                        $this->companyTripeditFunction($data);
                        break;
                    case 'companytrip_list':
                        $this->companyTripListFunction($data);
                        break;  
                    case 'file_generate':
                        $this->solotripFileGenerate ($data);
                        break;
                    case 'invoice_generate':
                        $this->invoiceGenerate ($data);
                        break; 
                    case 'submit_trip':
                        $this->tripfinalSubmition ($data);
                        break;
                    case 'pending_tripList':
                        $this->pendingTripList ($data);
                        break;
                    case 'history_delete':
                        $this->historydelete ($data);
                        break;
                    case 'duty_details_add':
                        $this->adminDutyDetailsAdd ($data);
                        break;
                    case 'duty_details_edit':
                        $this->adminDutyDetailsEdit ($data);
                        break;
                    case 'duty_details_get':
                        $this->adminDutyDetailsget ($data);
                        break;                   
                    default:
                        echo json_encode(['msg' => false, 'message' => 'Invalid service_id']);
                        break;
                }
            }else{
               echo json_encode(['msg' => false, 'message' => 'service id is missing']);
            }
        } else {
            echo "SERVER STARTED";
        }
    }

    private function handleLogin($data)
    {
        if (isset($data['mobile']) && isset($data['password'])) {
            $mobile = $data['mobile'];
            $password = $data['password'];
            $active_flag = 1;
            $stmt = $this->db->prepare("SELECT * FROM users WHERE mobile = ?");
            $stmt->bind_param("s", $mobile);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows == 0) {
            echo json_encode(['msg' => false, 'message' => 'User not found']);
            }else{
                $row = $result->fetch_assoc();
                if($active_flag != $row['active_flag']){
                     echo json_encode(['msg' => false, 'message' => 'Your account has been deactivate']);
                  } else if ($password != $row['password']) {
                    echo json_encode(['msg' => false, 'message' => 'Incorrect password']);
                } else {
                    echo json_encode(['msg' => true, 'data' => $row]);
                }
          } 
           $stmt->close();
        }else{
            echo json_encode(['msg' => false, 'message' => 'Mobile and Password is missing']);
        }exit;
    }

    private function handleRegister($data)
    {
        $name = $data['name'];
        $mobile = $data['mobile'];
        $password = $data['password'];
        $role = $data['role'];
        $dl_no = $data['dl_no'];
        $aadhar_no = $data['aadhar_no'];
        $active_flag = 1;
        $cart_amt = "0";
    
        $sel_stmt = $this->db->prepare("SELECT * FROM users WHERE mobile = ?");
        $sel_stmt->bind_param('s', $mobile);
        $sel_stmt->execute();
        $sel_res = $sel_stmt->get_result();
            if ($sel_res->num_rows) {
                echo json_encode(['msg' => false, 'message' => 'User already exists']);
                exit;
            }
        $sel_stmt->close();

        $img_path = null;
         if (isset($_FILES['profile_img'])) {
            $ext = pathinfo($_FILES['profile_img']['name'], PATHINFO_EXTENSION);
            $img_name = uniqid() . '.' . $ext;

            $directoryPath = "uploads/";
            if (!file_exists($directoryPath)) {
              mkdir($directoryPath, 0777, true);
            }

            $img_path = $directoryPath . $img_name;

         if (file_exists($img_path)) {
            $img_name = uniqid() . '.' . $ext;
            $img_path = $directoryPath . $img_name;
            }

            move_uploaded_file($_FILES['profile_img']['tmp_name'], $img_path);
         }

        $stmt = $this->db->prepare("INSERT INTO users (name, role, mobile, password, imgurl, dl_no, aadhar_no, active_flag, cart_amt) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)");
        $stmt->bind_param("sssssssis", $name, $role, $mobile, $password, $img_path, $dl_no, $aadhar_no, $active_flag, $cart_amt);

        if ($stmt->execute()) {
            $insertedId = $stmt->insert_id;
            $res = $this->db->query("SELECT * FROM users WHERE _id = $insertedId");
            if ($res) {
                $row = $res->fetch_assoc();
                echo json_encode(['msg' => true, 'message' => 'Registration Success', 'data' => $row]);
            }
        $this->db->commit();
        } else {
            echo json_encode(['msg' => false, 'message' => 'Registration failed']);
            $this->db->rollback();
        }

        $stmt->close();
        exit;
    }
    
    private function forgotPassword($data)
    {
     $mobile = $data['mobile'];
     $new_password = $data['password'];
    
        $sel_stmt = $this->db->prepare("SELECT * FROM users WHERE mobile = ?");
        $sel_stmt->bind_param('s', $mobile);
        $sel_stmt->execute();
        $result = $sel_stmt->get_result();
        if ($result->num_rows==0) {
        echo json_encode(['msg' => false, 'message' => 'This mobile number not register.']);
        exit;
        }     
        $sel_stmt->close();
        $row = $result->fetch_assoc();
        $stmt2 = $this->db->prepare("UPDATE users SET password =? WHERE _id =?");
        $stmt2->bind_param("ss",$new_password,$row['_id']);
            if ($stmt2->execute()) {
            echo json_encode(['msg' => true, 'message' => 'Password Updated']);
            $this->db->commit();
        } else {
            echo json_encode(['msg' => false, 'message' => 'Error']);
            $this->db->rollback();
        }
        $stmt2->close();
        exit;
    }
    
    private function userDeactivate($data)
    {
     $user_id = $data['_id'];
     $active_flag = $data['active_flag'];    
      
        $stmt1 = $this->db->prepare("UPDATE users SET active_flag =? WHERE _id =?");
        $stmt1->bind_param("ss",$active_flag,$user_id);
            if ($stmt1->execute()) {
            echo json_encode(['msg' => true, 'message' => 'User Status Updated']);
            $this->db->commit();
        } else {
            echo json_encode(['msg' => false, 'message' => 'Error']);
            $this->db->rollback();
        }
        $stmt1->close();
    }
   
    private function driversList($data)
    {
           $role = "Driver";
           $stmt = $this->db->prepare("SELECT * FROM users  WHERE role =?");
           $stmt->bind_param("s",$role);
           $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows == 0) {
            echo json_encode(['msg' => true,"total_amount"=>"0", 'data' => []]);
            }else{
            $drivers = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array
            $totalSalary = 0;
          // Loop through array and sum salaries
          foreach ($drivers as $json) {
            if (isset($json['cart_amt'])) {
                $totalSalary += $json['cart_amt'];
            }
            }

            echo json_encode(['msg' => true,"total_amount"=>$totalSalary, 'data' => $drivers]);
            } 
           $stmt->close();  
        exit;
    }

    private function addNewCar($data)
    {
        $car_name = $data['car_name'];
        $reg_no = $data['reg_no'];
        $rent_amount=$data['rental_amount'];
        $active_flag = 1;
        $upperregno = strtoupper($reg_no);

        $sel_stmt = $this->db->prepare("SELECT * FROM cars WHERE reg_no = ?");
        $sel_stmt->bind_param('s', $upperregno);
        $sel_stmt->execute();
        $sel_res = $sel_stmt->get_result();
        if ($sel_res->num_rows) {
        echo json_encode(['msg' => false, 'message' => 'Car details already exits']);
        exit;
        }
        $sel_stmt->close();

  
        $stmt = $this->db->prepare("INSERT INTO cars (car_name, reg_no,rent_amount, active_flag) VALUES (?, ?, ?,?)");
        $stmt->bind_param("sssi", $car_name, $upperregno,$rent_amount, $active_flag);
        if ($stmt->execute()) {
        $insertedId = $stmt->insert_id;
        $res = $this->db->query("SELECT * FROM cars WHERE _id = $insertedId");
        if ($res) {
            $row = $res->fetch_assoc();
            echo json_encode(['msg' => true, 'data' => $row]);
        }
        $this->db->commit();
         } else {
        echo json_encode(['msg' => false, 'message' => 'Car Registration failed']);
        $this->db->rollback();
        }

        $stmt->close();
        exit;
    }

    private function carDeactivate($data)
    {
        $car_id = $data['_id'];
        $active_flag = $data['active_flag'];    
        $stmt1 = $this->db->prepare("UPDATE cars SET active_flag =? WHERE _id =?");
        $stmt1->bind_param("ss",$active_flag,$car_id);
        if ($stmt1->execute()) {
          echo json_encode(['msg' => true, 'message' => 'Car Status Updated']);
          $this->db->commit();
        } else {
          echo json_encode(['msg' => false, 'message' => 'Error']);
          $this->db->rollback();
        }
        $stmt1->close();
    }
   
    private function carList($data)
    {
        $stmt = $this->db->prepare("SELECT * FROM cars");
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
          echo json_encode(['msg' => true, 'data' => []]);
        }else{
          $cars = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array
          echo json_encode(['msg' => true, 'data' => $cars]);
        } 
        $stmt->close();  
        exit;
    }

    private function datewiseTripList($data)
    {
        $datestr = $data['date'];
        $is_pending=1;
        $stmt = $this->db->prepare("SELECT * FROM trips_list WHERE trip_date = ? AND is_pending = ? ORDER BY _id DESC");
        $stmt->bind_param("si", $datestr,$is_pending);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
          echo json_encode(['msg' => true,'over_all_amount'=>"0", 'data' => []]);
        }else{
          $triplisttemp = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array

          $totalSalary = 0;
          // Loop through array and sum salaries
          foreach ($triplisttemp as $json) {
            if (isset($json['balance_amount'])) {
                $totalSalary += $json['balance_amount'];
            }
            }

          echo json_encode(['msg' => true,'over_all_amount'=>$totalSalary, 'data' => $triplisttemp]);
        } 
        $stmt->close();  
        exit;
    }
    
    private function newTripaddFunction($data)
    {
        $trip_date= $data['trip_date'];
        $vehicle_no= $data['vehicle_no'];
        $driver_id=  $data['driver_id'];
        $ola_cash= $data['ola_cash'];
        $ola_operator= $data['ola_operator'];
        $uber_cash= $data['uber_cash'];
        $uber_operator= $data['uber_operator'];
        $rapido_cash= $data['rapido_cash'];
        $rapido_operator= $data['rapido_operator'];
        $other_cash= $data['other_cash'];
        $duty_desc= $data['duty_desc'];
        $other_operator= $data['other_operator'];
        $total_cash_amt= $data['total_cash_amt'];
        $total_operator_amt= $data['total_operator_amt'];
        $salary_percentage= $data['salary_percentage'];
        $driver_salary= $data['driver_salary'];
        $fuel_details= $data['fuel_details'];
        $fuel_amt= $data['fuel_amt'];
        $other_expences=!empty($data['other_expences']) ? (float)$data['other_expences'] : 0.0;
        $balance_amount= $data['balance_amount'];
        $other_desc= $data['other_desc'];
        $kilometer= $data['kilometer'];
        $per_km= $data['per_km'];
        $is_pending = 0;      
     
       // 1. Insert trip
       $stmt = $this->db->prepare("
        INSERT INTO trips_list (trip_date,vehicle_no,driver_id,ola_cash,ola_operator,uber_cash,uber_operator,
        rapido_cash,rapido_operator,other_cash,other_operator,duty_desc,total_cash_amt,total_operator_amt,
        salary_percentage,driver_salary,fuel_details,fuel_amt,other_expences, balance_amount,other_desc,kilometer,per_km,is_pending
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)");

        $stmt->bind_param("sssssssssssssssssssssssi",$trip_date,$vehicle_no,$driver_id,$ola_cash,$ola_operator,
              $uber_cash,$uber_operator,$rapido_cash,$rapido_operator,$other_cash,$other_operator,$duty_desc,$total_cash_amt,
              $total_operator_amt,$salary_percentage,$driver_salary,$fuel_details,$fuel_amt,$other_expences,$balance_amount,
              $other_desc,$kilometer,$per_km,$is_pending);

        $stmt->execute();
        $trip_id = $this->db->insert_id;
        $stmt->close();
       echo json_encode(['msg' => true, 'message' => 'Trip has been successfully created.']);    
     exit;
    }
   
    private function editTripFunction($data)
    {
        $trip_id= $data['trip_id'];
        $trip_date= $data['trip_date'];
        $vehicle_no= $data['vehicle_no'];
        $driver_id=  $data['driver_id'];
        $ola_cash= $data['ola_cash'];
        $ola_operator= $data['ola_operator'];
        $uber_cash= $data['uber_cash'];
        $uber_operator= $data['uber_operator'];
        $rapido_cash= $data['rapido_cash'];
        $rapido_operator= $data['rapido_operator'];
        $other_cash= $data['other_cash'];
        $other_operator= $data['other_operator'];
        $duty_desc= $data['duty_desc'];
        $total_cash_amt= $data['total_cash_amt'];
        $total_operator_amt= $data['total_operator_amt'];
        $salary_percentage= $data['salary_percentage'];
        $driver_salary= $data['driver_salary'];
        $fuel_details= $data['fuel_details'];
        $fuel_amt= $data['fuel_amt'];
        $other_expences= $data['other_expences'];
        $balance_amount= $data['balance_amount'];
        $other_desc= $data['other_desc'];
        $kilometer= $data['kilometer'];
        $per_km= $data['per_km'];
        $is_pending = 0;   

        // 1. Update Trip details
        $stmt = $this->db->prepare("UPDATE trips_list SET trip_date = ?, vehicle_no = ?, driver_id = ?, ola_cash = ?, 
           ola_operator = ?, uber_cash = ?, uber_operator = ?,rapido_cash = ?, rapido_operator = ?, other_cash = ?,
           other_operator = ?, total_cash_amt = ?, total_operator_amt = ?,salary_percentage = ?, driver_salary = ?,driver_salary = ?,fuel_details =?, fuel_amt = ?,
           other_expences = ?,  balance_amount = ?,other_desc= ?,kilometer= ?,per_km =?,duty_desc = ?,is_pending = ? WHERE _id = ?");
        $stmt->bind_param("ssssssssssssssssssssssssii",$trip_date,$vehicle_no,$driver_id,$ola_cash,$ola_operator,
              $uber_cash,$uber_operator,$rapido_cash,$rapido_operator,$other_cash,$other_operator,$total_cash_amt,
              $total_operator_amt,$salary_percentage,$driver_salary,$driver_salary,$fuel_details,$fuel_amt,
              $other_expences,$balance_amount,$other_desc,$kilometer,$per_km,$duty_desc,$is_pending,$trip_id);
        $stmt->execute();
        $stmt->close();       
     
        echo json_encode(['msg' => true, 'message' => "Trip has been successfully updated."]);
        exit;
    }
   
    private function deleteFunction($data)
    {
        $trip_id= $data['trip_id'];
        $stmt = $this->db->prepare("DELETE FROM trips_list WHERE _id = ?");
        $stmt->bind_param("s", $trip_id);
        $stmt->execute();
        $stmt->close();
       echo json_encode(['msg' => true, 'message' => 'Trip has been successfully deleted.']);    
     exit;
    }

    private function cartAmountUpdate($data)
    {
        $driver_id=  $data['driver_id'];
        $type= $data['type'];
        $amount= $data['amount'];
        $add_reason = "";
        $payment_type = "";
        if(isset($data['add_reason'])){
         $add_reason = $data['add_reason'];
        }
         if(isset($data['payment_type'])){
         $payment_type = $data['payment_type'];
        }

        // 1. Get driver details
        $stmt = $this->db->prepare("SELECT cart_amt FROM users WHERE _id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $stmt->bind_result($cart_amt);
        $stmt->fetch();
        $stmt->close();

        // 2. Update Cart Amount
         if($type=="Add Amount"){
          $updatedCartAmt = floatval($cart_amt) + floatval($amount) ;
        }else{
            $updatedCartAmt = floatval($cart_amt) - floatval($amount) ;
        }
        $stmt = $this->db->prepare("UPDATE users SET cart_amt = ? WHERE _id = ?");
        $stmt->bind_param("si", $updatedCartAmt, $driver_id);
        $stmt->execute();
        $stmt->close();
        
        // 3. Insert the Transaction History
        $active_flag=1;
        $stmt = $this->db->prepare("
        INSERT INTO transaction_history (driver_id,trip_amount,add_reason,add_deduct_type,payment_type,active_flag ) VALUES (?,?,?,?,?,?)");
        $stmt->bind_param("issssi",$driver_id,$amount,$add_reason,$type,$payment_type,$active_flag );

        $stmt->execute();
        $trip_id = $this->db->insert_id;
        $stmt->close();

        echo json_encode(['msg' => true, 'message' => "Cart Amount successfully updated.", "amount"=>$updatedCartAmt ]);    
        exit;
    }
   
    private function tripListLdriver($data)
    {
        $datestr = $data['date'];
        $driver_id = $data['driver_id'];
        
        if($datestr == "All"){
        $stmt = $this->db->prepare("SELECT * FROM trips_list WHERE driver_id = ? ORDER BY _id DESC");
        $stmt->bind_param("i", $driver_id);

        }else{
        $stmt = $this->db->prepare("SELECT * FROM trips_list WHERE  driver_id = ? AND trip_date = ?   ORDER BY _id DESC");
        $stmt->bind_param("is",$driver_id, $datestr);

        }
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
          echo json_encode(['msg' => true, 'data' => []]);
        }else{
          $cars = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array
          echo json_encode(['msg' => true, 'data' => $cars]);
        } 
        $stmt->close();  
        exit;
    }

    private function transactionHistory($data)
    {
        $driver_id = $data['driver_id'];
        $active_flag=1;
        $stmt = $this->db->prepare("SELECT * FROM transaction_history WHERE driver_id = ? AND active_flag = ? ORDER BY _id DESC LIMIT 100");
        $stmt->bind_param("si", $driver_id,$active_flag);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
          echo json_encode(['msg' => true, 'data' => []]);
        }else{
          $listdata = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array
         echo json_encode(['msg' => true,'data' => $listdata]);
        } 
        $stmt->close();  
        exit;
    }
    
    private function newCustomer($data)
    {
        $name = $data['name'];
        $active_flag = 1;
        $uppername = strtoupper($name);

        $sel_stmt = $this->db->prepare("SELECT * FROM customers WHERE name = ?");
        $sel_stmt->bind_param('s', $uppername);
        $sel_stmt->execute();
        $sel_res = $sel_stmt->get_result();
        if ($sel_res->num_rows) {
        echo json_encode(['msg' => false, 'message' => 'Customer Name already exits']);
        exit;
        }
        $sel_stmt->close();

  
        $stmt = $this->db->prepare("INSERT INTO customers (name, active_flag) VALUES (?, ?)");
        $stmt->bind_param("si",$uppername,$active_flag);
        if ($stmt->execute()) {
        $insertedId = $stmt->insert_id;
        $res = $this->db->query("SELECT * FROM customers WHERE _id = $insertedId");
        if ($res) {
            $row = $res->fetch_assoc();
            echo json_encode(['msg' => true, 'data' => $row]);
        }
        $this->db->commit();
         } else {
        echo json_encode(['msg' => false, 'message' => 'Customer Registration failed']);
        $this->db->rollback();
        }

        $stmt->close();
        exit;
    }

    private function customerList($data)
    {
        $stmt = $this->db->prepare("SELECT * FROM customers");
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
          echo json_encode(['msg' => true, 'data' => []]);
        }else{
          $cars = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array
          echo json_encode(['msg' => true, 'data' => $cars]);
        } 
        $stmt->close();  
        exit;
    }

    private function companyTripaddFunction($data)
    {
        $vehicle_no= $data['vehicle_no'];
        $driver_id=  $data['driver_id'];
        $customer_id= $data['customer_id'];
        $pickup_place= $data['pickup_place'];
        $drop_place= $data['drop_place'];
        $pickup_time= $data['pickup_time'];
        $drop_time= $data['drop_time'];
        $total_hr= $data['total_hr'];
        $package_amount= $data['package_amount'];
        $km= $data['km'];
        $extra_km= $data['extra_km'];
        $extra_km_amount= $data['extra_km_amount'];
        $toll_amt= $data['toll_amt'];
        $driver_salary= $data['driver_salary'];
        $parking= $data['parking'];
        $other_amount= $data['other_amount'];
        $description= $data['description'];
        $advance_amt= $data['advance_amt'];
        $balance_amount= $data['balance_amount'];
       
       
        // 1. Insert company trip
       $stmt = $this->db->prepare("
        INSERT INTO company_trips (km,vehicle_no,driver_id,customer_id,pickup_place,drop_place,
        pickup_time,drop_time,total_hr,package_amount,toll_amt,extra_km,extra_km_amount,
        driver_salary,parking,other_amount,description,advance_amt,balance_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

        $stmt->bind_param("sssssssssssssssssss",$km,$vehicle_no,$driver_id,$customer_id,
              $pickup_place,$drop_place,$pickup_time,$drop_time,$total_hr,$package_amount,$extra_km,$extra_km_amount,
              $toll_amt,$driver_salary,$parking,$other_amount,$description,$advance_amt,$balance_amount);

        if ($stmt->execute()) {
        $insertedId = $stmt->insert_id;
        $res = $this->db->query("SELECT * FROM company_trips WHERE _id = $insertedId");
        if ($res) {
            $row = $res->fetch_assoc();
            echo json_encode(['msg' => true, 'data' => $row]);
        }
         } else {
        echo json_encode(['msg' => false, 'message' => 'Trip Registration failed']);
        }

        $stmt->close();             
     exit;
    }
    
    private function companyTripeditFunction($data)
    {
        $trip_id= $data['trip_id'];
        $vehicle_no= $data['vehicle_no'];
        $driver_id=  $data['driver_id'];
        $customer_id= $data['customer_id'];
        $pickup_place= $data['pickup_place'];
        $drop_place= $data['drop_place'];
        $pickup_time= $data['pickup_time'];
        $drop_time= $data['drop_time'];
        $total_hr= $data['total_hr'];
        $package_amount= $data['package_amount'];
        $km= $data['km'];
        $extra_km= $data['extra_km'];
        $extra_km_amount= $data['extra_km_amount'];
        $toll_amt= $data['toll_amt'];
        $driver_salary= $data['driver_salary'];
        $parking= $data['parking'];
        $other_amount= $data['other_amount'];
        $description= $data['description'];
        $advance_amt= $data['advance_amt'];
        $balance_amount= $data['balance_amount'];

        // 1. Update Company Trip details
        $stmt = $this->db->prepare("UPDATE company_trips SET km = ?, vehicle_no = ?, driver_id = ?, customer_id = ?, 
           pickup_place = ?, drop_place = ?, pickup_time = ?,drop_time = ?,total_hr = ?, package_amount = ?, extra_km = ?, extra_km_amount = ?,
           toll_amt = ? , driver_salary = ? , parking = ? , other_amount = ? , description = ? , advance_amt = ? , balance_amount = ?
           WHERE _id = ?");
        $stmt->bind_param("sssssssssssssssssssi",$km,$vehicle_no,$driver_id,$customer_id,$pickup_place,
              $drop_place,$pickup_time,$drop_time, $total_hr,$package_amount,$extra_km, $extra_km_amount, 
              $toll_amt,$driver_salary,$parking,$other_amount,$description,$advance_amt,$balance_amount,$trip_id);
        if ($stmt->execute()) {
        $res = $this->db->query("SELECT * FROM company_trips WHERE _id = $trip_id");
        if ($res) {
            $row = $res->fetch_assoc();
            echo json_encode(['msg' => true, 'data' => $row]);
        }
         } else {
        echo json_encode(['msg' => false, 'message' => 'Trip Registration failed']);
        }
        $stmt->close();

     exit;
    }
    
    private function companyTripListFunction($data)
    {
        $result=   $this->getTripListFunction($data);
        echo json_encode(['msg' => true, 'data' => $result]);
        exit;
    }
    
    private function getTripListFunction($data)
    {
        $customer_id = $data['customer_id'];
        $from = explode('-', $data['from_date']);
        $from_date = $from[1] . '-' . $from[0] . '-01';
        $to_date = $from[1] . '-' . $from[0] . '-31';

        $stmt = $this->db->prepare("SELECT * FROM company_trips WHERE customer_id = ? AND DATE(created_date) BETWEEN DATE(?) AND DATE(?)");
        $stmt->bind_param("sss",$customer_id, $from_date, $to_date);
        $stmt->execute();
        $result = $stmt->get_result();
          $datalists = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array

        $stmt->close();  
       return $datalists;
    }

    private function solotripFileGenerate($data)
    {
            $from = explode('-', $data['from_date']);
            $from_date = $from[1] . '-' . $from[0] . '-01';
            $to_date = $from[1] . '-' . $from[0] . '-31';
            $stmt = $this->db->prepare("SELECT t.trip_date,u.name,
            t.vehicle_no,t.ola_operator,t.uber_operator,t.rapido_operator,
            t.other_operator,t.total_cash_amt,t.total_operator_amt,t.salary_percentage,t.driver_salary,
            t.fuel_amt,t.other_expences,t.rent_amount,t.kilometer,t.profit 
            FROM trips_list t INNER JOIN users u ON t.driver_id = u._id WHERE DATE(created_date) BETWEEN DATE(?) AND DATE(?)");
            $stmt->bind_param("ss", $from_date, $to_date);
            $stmt->execute();            
            $result = $stmt->get_result();
            $stmt->close();            
             
            $solotriplist = $result->fetch_all(MYSQLI_ASSOC);             
            $path1 =  $data['from_date']."_trips_reports.csv";
            //$output = fopen($path1, "w");
            $output = fopen('php://temp', 'r+');
            $headertxt = array("Date", "Driver Name","Vehicle Number","Ola Operator","Uber Operator","Rapido Operator","Other Cash","Total Cash Amount","Total Operator Amount", "Salary (%)","Driver Salary", "Fuel", "Other Expences", "Car Rent","KM","Profit");
            
            fputcsv($output, $headertxt); //Write header row
            
            foreach ($solotriplist as $row) { // Write data rows
            fputcsv($output, $row);
            }
            rewind($output);
            $csvContent1 = stream_get_contents($output);
            fclose($output);

            $stmt = $this->db->prepare("SELECT t.trip_date,u.name,t.vehicle_no,t.customer_id,t.pickup_place,t.drop_place,t.pickup_time,t.drop_time,t.amount
            FROM company_trips t INNER JOIN users u ON t.driver_id = u._id WHERE DATE(created_date) BETWEEN DATE(?) AND DATE(?)");
            $stmt->bind_param("ss", $from_date, $to_date);
            $stmt->execute();
            $result = $stmt->get_result();
            $stmt->close();   
            $companytriplist = $result->fetch_all(MYSQLI_ASSOC);
             
            $path2 =  $data['from_date']."_company_trips_reports.csv";
          
            //$output = fopen($path2, "w");
            $output = fopen('php://temp', 'r+');
            $headertxt = array("Date", "Driver Name","Vehicle Number","Customer Name","Pickup Location","Drop Location","Pickup Time","Drop Time","Amount");
            //Write header row
            fputcsv($output, $headertxt);

            // Write data rows
            foreach ($companytriplist as $row) {
            fputcsv($output, $row);
            }
            rewind($output);
            $csvContent2 = stream_get_contents($output);
            fclose($output);    
             $attachments = [
                 ['content' => $csvContent1, 'name' => $path1],
                 ['content' => $csvContent2, 'name' => $path2],
             ];         
           $this->sendEmail( $attachments);
        exit;
    }   
 
    private function invoiceGenerate($data)
    {

         $resdata=   $this->getTripListFunction($data);

         $customer_id = $data['customer_id'];
         // 1. Get driver details
        $stmt = $this->db->prepare("SELECT name FROM customers WHERE _id = ?");
        $stmt->bind_param("i", $customer_id);
        $stmt->execute();
        $stmt->bind_result($cusname);
        $stmt->fetch();
        $stmt->close();
        
         $totalBalance = 0;
        foreach ($resdata as $row) {
         if (isset($row['balance_amount'])) {
         $totalBalance += $row['balance_amount'];
         }
        }

       // Setup mpdf
        $mpdf = new Mpdf([
        'margin_left'   => 5,  
        'margin_right'  => 5,  
        'margin_top'    => 10,
        'margin_bottom' => 10,  
        'margin_header' => 0, 
        'margin_footer' => 0,  
        ]); 


        $datsssa = [
            'invoice_no' => "01",
            'date' => date("d.m.Y"),
            'name' => $cusname,
            'resdata' => $resdata,
            'total_amt' => $totalBalance 
                
        ];
        
        extract($datsssa);
        ob_start();
        include "./documents/invoice.php";
        $html = ob_get_clean();
        $mpdf->WriteHTML($html);
        $pdfname = $data['from_date'] . "_" . $cusname . "_invoice.pdf";
        $pdfContent = $mpdf->Output('', 'S');

        $attachments = [
           ['content' => $pdfContent, 'name' => $pdfname],
         ];

      $this->sendEmail( $attachments);
    }
  
    private function tripfinalSubmition($data)
    {
        $trip_id= $data['trip_id'];

        // 1. Get Trip details
        $stmt = $this->db->prepare("SELECT vehicle_no,total_operator_amt,driver_salary,fuel_amt,other_expences,driver_id,balance_amount  FROM trips_list WHERE _id = ?");
        $stmt->bind_param("i", $trip_id);
        $stmt->execute();
        $stmt->bind_result($vehicle_no,$total_operator_amt,$driver_salary,$fuel_amt,$other_expences,$driver_id,$balance_amount);
        $stmt->fetch();
        $stmt->close();

         // 2. Get Car details
        $stmt = $this->db->prepare("SELECT rent_amount FROM cars WHERE reg_no = ?");
        $stmt->bind_param("s", $vehicle_no);
        $stmt->execute();
        $stmt->bind_result($rentamt);
        $stmt->fetch();

        $perdayRent = round(floatval($rentamt) / 30, 2);
        $profit = round( floatval($total_operator_amt)-$perdayRent-floatval($driver_salary)-floatval($fuel_amt)-floatval($other_expences));
        $stmt->close();


        // 3. Update Trip details
        $is_pending = 1;
        $stmt = $this->db->prepare("UPDATE trips_list SET rent_amount = ?, profit = ?,is_pending = ? WHERE _id = ?");
        $stmt->bind_param("ssii",$perdayRent,$profit,$is_pending, $trip_id);
        $stmt->execute();
        $stmt->close();        
        
        // 4. Get driver details
        $stmt = $this->db->prepare("SELECT cart_amt FROM users WHERE _id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $stmt->bind_result($cart_amt);
        $stmt->fetch();
        $updatedCartAmt = floatval($cart_amt)  + floatval($balance_amount);
        $stmt->close();


        // 5. Update Cart Amount
        $stmt = $this->db->prepare("UPDATE users SET cart_amt = ? WHERE _id = ?");
        $stmt->bind_param("si", $updatedCartAmt, $driver_id);
        $stmt->execute();
        $stmt->close();
        
        // 6. Insert the Transaction History
        $isedit = 1;
        $stmt = $this->db->prepare("
        INSERT INTO transaction_history (driver_id,trip_id,trip_amount,is_edit,old_data,active_flag ) VALUES (?, ?, ?,?,?,?)");
        $stmt->bind_param("sssisi",$driver_id,$trip_id,$balance_amount,$isedit,$old_balance_amount,$isedit );

        $stmt->execute();
        $trip_id = $this->db->insert_id;
        $stmt->close();

        echo json_encode(['msg' => true, 'message' => "Trip has been successfully submited."]);
        exit;
    }
    
    private function historydelete($data)
    {
        $history_id= $data['history_id'];

        // 1. Get History details
        $stmt = $this->db->prepare("SELECT driver_id, trip_amount,add_deduct_type FROM transaction_history WHERE _id = ?");
        $stmt->bind_param("i", $history_id);
        $stmt->execute();
        $stmt->bind_result($driver_id,$trip_amount,$add_deduct_type);
        $stmt->fetch();
        $stmt->close();
       
        // 3. Update History details
        $active_flag = 0;
        $stmt = $this->db->prepare("UPDATE transaction_history SET active_flag = ? WHERE _id = ?");
        $stmt->bind_param("ii",$active_flag, $history_id);
        $stmt->execute();
        $stmt->close();        
        
       
        // 4. Get driver details
        $stmt = $this->db->prepare("SELECT cart_amt FROM users WHERE _id = ?");
        $stmt->bind_param("i", $driver_id);
        $stmt->execute();
        $stmt->bind_result($cart_amt);
        $stmt->fetch();
        $stmt->close();
   

        // 5. Update Cart Amount
        $updatedCartAmt;
        if($add_deduct_type=="Deduct Amount"){
        $updatedCartAmt = floatval($cart_amt)  + floatval($trip_amount);
        }else{
        $updatedCartAmt = floatval($cart_amt)  - floatval($trip_amount);
        }

        $stmt = $this->db->prepare("UPDATE users SET cart_amt = ? WHERE _id = ?");
        $stmt->bind_param("si", $updatedCartAmt, $driver_id);
        $stmt->execute();
        $stmt->close();
           echo json_encode(['msg' => true, 'message' => "Successfully deleted the history", 'amount'=>$updatedCartAmt ]);
        exit;
    }

    private function pendingTripList($data)
    {
        $is_pending=0;
        $stmt = $this->db->prepare("SELECT * FROM trips_list WHERE  is_pending = ?");
        $stmt->bind_param("i", $is_pending);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
          echo json_encode(['msg' => true,'data' => []]);
        }else{
          $triplisttemp = $result->fetch_all(MYSQLI_ASSOC);         
          echo json_encode(['msg' => true, 'data' => $triplisttemp]);
        } 
        $stmt->close();  
        exit;
    }
    
    private function adminDutyDetailsAdd($data)
    {
        $hr_amount = $data['hr_amount'];
        $ex_km_amount = $data['ex_km_amount'];
        $per_hr_km	=$data['per_hr_km'];
       
        $stmt = $this->db->prepare("INSERT INTO admin_duty_details (hr_amount, ex_km_amount, per_hr_km) VALUES (?, ?, ?)");
        $stmt->bind_param("sss", $hr_amount, $ex_km_amount, $per_hr_km);
        if ($stmt->execute()) {
        echo json_encode(['msg' => true, 'message' => 'Registration Success']);
          $this->db->commit();
         } else {
        echo json_encode(['msg' => false, 'message' => 'Registration failed']);
        $this->db->rollback();
        }

        $stmt->close();
        exit;
    }

    private function adminDutyDetailsEdit($data)
    {
         $uid = $data['uid'];
        $hr_amount = $data['hr_amount'];
        $ex_km_amount = $data['ex_km_amount'];
        $per_hr_km	=$data['per_hr_km'];   
      
        $stmt1 = $this->db->prepare("UPDATE admin_duty_details SET hr_amount = ?, ex_km_amount = ?, per_hr_km = ? WHERE _id =?");
        $stmt1->bind_param("sssi",$hr_amount,$ex_km_amount,$per_hr_km,$uid);
        if ($stmt1->execute()) {
             $stmt2 = $this->db->prepare("SELECT * FROM admin_duty_details WHERE _id = ?");
             $stmt2->bind_param("i", $uid);
             $stmt2->execute();
            $result = $stmt2->get_result();
            $updatedRow = $result->fetch_assoc();
            $stmt2->close();

            echo json_encode(['msg' => true,'data' => $updatedRow ]);
            $this->db->commit();
        } else {
          echo json_encode(['msg' => false, 'message' => 'Admin duty failed']);
          $this->db->rollback();
        }
        $stmt1->close();
    }
    
    private function adminDutyDetailsget($data)
    {
        $uid = 1;      
        $sel_stmt = $this->db->prepare("SELECT * FROM admin_duty_details WHERE _id = ?");
        $sel_stmt->bind_param('i', $uid);
        $sel_stmt->execute();
        $sel_res = $sel_stmt->get_result();       
        if ($sel_res->num_rows) {
            $row = $sel_res->fetch_assoc();
            echo json_encode(['msg' => true, 'data' => $row]);
        exit;
        }
        $sel_stmt->close();
        exit;
    }
    
    private function sendEmail($attachments)
    {
      $mail = new PHPMailer(true);
       try {
        // SMTP settings
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'mbaasha018@gmail.com'; 
        $mail->Password   = 'rhtn kcfe prpr khwm';  
        $mail->SMTPSecure = 'ssl';
        $mail->Port       = 465;

        // Email settings
        $mail->setFrom('mbaasha018@gmail.com', 'Mummy Cabs');
        $mail->addAddress('manimozhi167@gmail.com');
        //$mail->addAddress('tamilselvan1998.pdkt@gmail.com');

        $mail->isHTML(true);

         foreach ($attachments as $attach) {
            if (isset($attach['content']) && isset($attach['name'])) {
                $mail->addStringAttachment($attach['content'], $attach['name']);
            }
        }

        $mail->Subject = 'Monthly Perfomance Reports';
        $mail->Body = file_get_contents('./documents/email_body.php');

        $mail->send();
         echo json_encode(['msg' => true, 'message' => "Email sent successfully."]);
       
        } catch (Exception $e) {
          echo json_encode(['msg' => false, 'message' => "Failed to send email. Error: " . $mail->ErrorInfo]);
      
        }
    }

      
}

$userController = new UserController();
$userController->handleRequest();