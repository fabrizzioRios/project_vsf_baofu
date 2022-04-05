<?php
    include("baofu.php");
    function fn02_post(){
        $server = "148.239.60.61";
        $user = "ids";
        $passwordBD = "ids";
        $db = "BaoFuBD_22";
        $connInfo = array("Database"=>$db, "UID"=>$user, "PWD"=>$passwordBD);

        $conexion = sqlsrv_connect($server,$connInfo);

        if ($conexion){
            //echo "Conectado";
            $strSQl = "SELECT * FROM Platillos";
            $resultados = sqlsrv_query($conexion, $strSQl);

            if($resultados == true){
                //$fila = sqlsrv_fetch_array($resultados,SQLSRV_FETCH_ASSOC);
                //echo $fila["Nombre"];
                while($fila = sqlsrv_fetch_array($resultados,SQLSRV_FETCH_ASSOC)){
                    $registro[] = $fila;
                }
                $strJSON = json_encode($registro);
                echo $strJSON;
            }
        }
        else{
            echo "No conectado";
            die(print_r(sqlsrv_errors()));
        }
    }//Fin función fn02_post

    if(isset($_POST["variablePost"]))
        fn02_post();
?>