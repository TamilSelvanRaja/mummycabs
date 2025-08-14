<?php
  

class UserController
{
    private $db;
    public function __construct()
    {
        // Initialize the database connection
      $this->db = new mysqli('localhost', 'root', '', 'mummy_cabs_db');
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
                    default:
                        echo json_encode(['msg' => false, 'message' => 'Invalid service_id']);
                        break;
                }
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

    $stmt = $this->db->prepare("INSERT INTO users (name, role, mobile, password, imgurl, dl_no, aadhar_no, active_flag) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssssi", $name, $role, $mobile, $password, $img_path, $dl_no, $aadhar_no, $active_flag);

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
            echo json_encode(['msg' => false, 'message' => 'Drivers not found']);
            }else{
            $drivers = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array
            echo json_encode(['msg' => true, 'data' => $drivers]);
            } 
           $stmt->close();  
        exit;
    }

    private function addNewCar($data)
    {
        $car_name = $data['car_name'];
        $reg_no = $data['reg_no'];
        $active_flag = 1;

        $sel_stmt = $this->db->prepare("SELECT * FROM cars WHERE reg_no = ?");
        $sel_stmt->bind_param('s', $reg_no);
        $sel_stmt->execute();
        $sel_res = $sel_stmt->get_result();
        if ($sel_res->num_rows) {
        echo json_encode(['msg' => false, 'message' => 'Call details already exits']);
        exit;
        }
        $sel_stmt->close();

  
        $stmt = $this->db->prepare("INSERT INTO cars (car_name, reg_no, active_flag) VALUES (?, ?, ?)");
        $stmt->bind_param("ssi", $car_name, $reg_no, $active_flag);
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
          echo json_encode(['msg' => false, 'message' => 'Cars not found']);
        }else{
          $cars = $result->fetch_all(MYSQLI_ASSOC); // Fetch all rows as array
          echo json_encode(['msg' => true, 'data' => $cars]);
        } 
        $stmt->close();  
        exit;
    }

}

$userController = new UserController();
$userController->handleRequest();