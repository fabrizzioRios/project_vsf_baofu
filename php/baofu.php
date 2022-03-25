<?php

    function conectar () {

        $servidor = "148.239.60.61";
        $usuarioDB = "ids";
        $passwordDB = "ids";
        $db = "BaoFuBD_22";
        $connInfo = array("Database" => $db, "UID" => $usuarioDB, "PWD"=>$passwordDB, "CharacterSet"=>"UTF-8");

        $conexion = sqlsrv_connect($servidor, $connInfo);

        return $conexion;
    }

    function registrar_usuario ($nombre, $usuario, $email, $telefono, $direccion, $pass) {
        $conn = conectar();
        echo "Hola";
        //'$nombre', '$usuario', '$correo', '$telefono', '$direccion', '$pass'
        if ($conn) {
            $strquery = "exec AgregarUsuario '$nombre', '$usuario', '$email', '$telefono', '$direccion', '$pass'";
            $resultados = sqlsrv_query($conn, $strquery);

            if ($resultados== TRUE ) {
                echo "Usuario agregado";
                sqlsrv_close($conn);
            } else {
                echo "El usuario no pudo ser agregado";
                sqlsrv_close($conn);
            }
        } else {
            echo "No estas conectado";
        }
    }

    function iniciar_sesion ($username, $password) {
        $conn = conectar();
        if ($conn) {
            $strquery = "exec log_in '$username' '$password'";

            $resultados = sqlsrv_query($conn, $strquery);  
            if ($resultados == True) {
                while ($fila = sqlsrv_fetch_array($resultados, SQLSRV_FETCH_ASSOC)) {
                    $registros[] = $fila;
                }
                $strJSON = json_encode($registros);
                echo $strJSON;
            }

            echo"Ya selecciono";

        } else {
            echo "No fue posible la conexion";
        }
    }

    if(isset($_POST["User"]))
        registrar_usuario($_POST["name"],$_POST["User"],$_POST["email"],$_POST["phone"],$_POST["address"],$_POST["password"]);
    if(isset($_POST["Username"]))
        iniciar_sesion($_POST["Username"],$_POST["password"]);

    

?>