<?php 
	function solicitarToken($user, $pass, $ambiente, $certificador){
		if ($certificador == 1) {
			$token_xml = "<?xml version='1.0' encoding='UTF-8'?>
			<SolicitaTokenRequest>
			<usuario>".$user."</usuario>
			<apikey>".$pass."</apikey>
			</SolicitaTokenRequest>";

			$ch = curl_init();
			if ($ambiente == 1) {
		      curl_setopt($ch, CURLOPT_URL,"https://apiv2.ifacere-fel.com/api/solicitarToken");
		    }else{
		      curl_setopt($ch, CURLOPT_URL,"https://dev2.api.ifacere-fel.com/api/solicitarToken");
		    }
			

			curl_setopt($ch, CURLOPT_VERBOSE, 1);
			curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);

			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $token_xml); 
			curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			  'Content-type: application/xml',
			  'Accept: application/xml'
			));

			// Receive server response ...
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

			if (curl_errno($ch)){
				$server_output = "Curl Error";
				// moving to display page to display curl errors
			  	//echo curl_errno($ch) ;
			  	//echo curl_error($ch);
			}else{
				$server_output = curl_exec($ch);
			}
			curl_close ($ch);
			return $server_output;
		}else if ($certificador == 2) {

			if ($ambiente == 1) {
		      $host = "https://receptor.fel.sigsa.gt/prod/Token";
		    }else{
		      $host = "https://receptor.fel.sigsa.gt/desa/Token";
		    }

			$curl = curl_init();

			curl_setopt_array($curl, array(
			  CURLOPT_URL => $host,
			  CURLOPT_RETURNTRANSFER => true,
			  CURLOPT_ENCODING => '',
			  CURLOPT_MAXREDIRS => 10,
			  CURLOPT_TIMEOUT => 0,
			  CURLOPT_FOLLOWLOCATION => true,
			  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
			  CURLOPT_CUSTOMREQUEST => 'GET',
			  CURLOPT_HTTPHEADER => array(
			    'Content-Type: application/xml',
			    'Authorization: Basic '.base64_encode($user.':'.$pass)
			  ),
			));

			$response = curl_exec($curl);
			
			if (curl_errno($curl)){
				$server_output = "Curl Error";
				// moving to display page to display curl errors
			  	//echo curl_errno($curl) ;
			  	//echo curl_error($curl);
			}else{
				$server_output = curl_exec($curl);
			}
			curl_close ($curl);
			return $server_output;
		}else if ($certificador == 3) {

			if ($ambiente == 1) {
		      $host = "https://felgtaws.digifact.com.gt/gt.com.fel.api.v3/api/login/get_token";
		    }else{
		      $host = "https://felgttestaws.digifact.com.gt/gt.com.fel.api.v3/api/login/get_token";
		    }

		    $json = array(
				"Username" => "GT.$user",
				"Password" => "$pass"
			);
			$json = json_encode($json);

			$curl = curl_init();

			curl_setopt_array($curl, array(
			  CURLOPT_URL => $host,
			  CURLOPT_RETURNTRANSFER => true,
			  CURLOPT_ENCODING => '',
			  CURLOPT_MAXREDIRS => 10,
			  CURLOPT_TIMEOUT => 0,
			  CURLOPT_FOLLOWLOCATION => true,
			  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
			  CURLOPT_CUSTOMREQUEST => 'POST',
			  CURLOPT_POSTFIELDS => $json,
			  CURLOPT_HTTPHEADER => array(
			    'Content-Type: application/json',
			    'Accept: application/json'
			  ),
			));

			$server_output = curl_exec($curl);

			curl_close ($curl);
			return $server_output;
		}
	}
 ?>