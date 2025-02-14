<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="HandheldFriendly" content="True">
	<meta name="MobileOptimized" content="320">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta http-equiv="cleartype" content="on">
	<meta name="description" content="MSGHUB API">
	<meta name="author" content="yub">
	<title>MSGHUB API</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.css">
	<style>
		table td{
			vertical-align: middle;
			font-size:13px;
		}
		.page-wrapper{
			padding: 0;
			margin: 0;
			min-height: 100vh;
			background: linear-gradient(to top right, #08aeea 0%, #b721ff 100%);
			padding-top: 45px;
			padding-bottom: 50px;
		}
		.wrapper--790{
			padding: 0;
			box-sizing: inherit;
			margin: 0 auto;
			max-width: 790px;
		}
		.card-5{
			padding: 0;
			margin: 0;
			box-sizing: inherit;
			background: #fff;
			border-radius: 10px;
			box-shadow: 0px 8px 20px 0px rgba(0, 0, 0, 0.15);
		}
		.card-heading{
			font-weight: 400;
			font-size: 14px;
			margin: 0;
			box-sizing: inherit;
			padding: 20px 0;
			background: #1a1a1a;
			border-top-left-radius: 10px;
			border-top-right-radius: 10px;
		}
		.title{
			box-sizing: inherit;
			margin: 0;
			padding: 0;
			font-size: 24px;
			font-weight: 700;
			text-align: center;
			color: #fff;
		}
	</style>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	
	<script type="text/javascript">
	
	$(function(){
		
		var response = ${response};
		//console.log('1=>'+JSON.stringify(response));
		//console.log('2=>'+response);
		
		if(response.code == "10000"){
			$("#result").val("토큰 생성 성공==>"+JSON.stringify(response));
			$("#token").val(response.data.token);
			$("#refreshToken").val(response.data.refreshToken);
		}else{
			$("#result").val("토큰 생성 실패==>"+JSON.stringify(response));
			$('#submitBtn').attr('disabled', true);
		}
		
		// 요청버튼 클릭
		$('#submitBtn').click(function(){
			ajaxSend();
		});
		
	    
		function ajaxSend() {
			
			// 데이터 가공
			var recvInfoLst = $("#recvInfoLst").serializeObject();
			var inputFrm = $("#inputFrm").serializeObject();
			var recvInfoLst2 = {
					recvInfoLst : JSON.stringify(recvInfoLst)
			};
			
			var param = Object.assign(inputFrm, recvInfoLst2);
			
			console.log("recvInfoLst==>"+JSON.stringify(recvInfoLst));
			console.log("inputFrm==>"+JSON.stringify(inputFrm));
			console.log("param==>"+JSON.stringify(param));

			
	    	$.ajax({
				url : "${pageContext.request.contextPath}/ajaxRequest"
				, type : "POST"
				, dataType : "json"
				, traditional: true
				, data : param
				, success : function(data) {
					console.log("data"+JSON.stringify(data));
					console.log("data.code"+data.code);
					if(data.code == '10000'){
						var request = $("#request").val();
						if(request == "refresh"){
							$("#token").val(data.data.token);	
						}
						$("#result").val("success ==>"+JSON.stringify(data));
					}else{
						$("#result").val("fail ==>"+JSON.stringify(data));
					}
				}
				, error : function(request,status,error){
					$("#result").val("error ==>"+"code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error+"status:"+status);
			    }
			});
		}
		
		$('#request').on("change", function(){
			var request = $('#request').val()
			if(request == "mms2" || request == "mms3"){
				console.log("mms2/mms3")
			}else if(request == "rpt"){
				console.log("rpt")
			}else if(request == "refresh"){
				console.log("refresh")
			}else{
				console.log("else")
			}
		});
		
		$.fn.serializeObject = function() {
			  "use strict"
			  var result = {}
			  var extend = function(i, element) {
			    var node = result[element.name]
			    if ("undefined" !== typeof node && node !== null) {
			      if ($.isArray(node)) {
			        node.push(element.value)
			      } else {
			        result[element.name] = [node, element.value]
			      }
			    } else {
			      result[element.name] = element.value
			    }
			  }

			  $.each(this.serializeArray(), extend)
			  return result
			}
	});	
	
	</script>
</head>
<body>
<div class="page-wrapper">
	<div class="wrapper--790">
		<div class="card-5">
			<div class="card-heading">
				<h2 class="title">MSGHUB API</h2>
			</div>
			<form id="inputFrm" name="inputFrm" action="" method="post">
				<input type="hidden" name="token" id="token" value="">
				<input type="hidden" name="refreshToken" id="refreshToken" value="">
				<p>
				<div class="container">
					<table class="table-sm table-bordered table-hover" style="width:100%;">
					<colgroup>
						<col width="30%">
						<col width="80%">
					</colgroup>
					<tbody>
						<tr>
							<td>Request</td>
							<td>
								<select class="form-control" id="request" name="request">
									<option value="refresh">인증갱신</option>
									<!-- 
									<option value="sms">SMS 발송</option>
									<option value="mms">MMS 발송(첨부파일 사전등록시)</option>
									<option value="mms2">이미지 사전등록</option>
									<option value="mms3">MMS 발송</option>
									<option value="rcs">RCS 발송</option>
									<option value="alimtalk">카카오 알림톡</option>
									<option value="friendtalk">카카오 친구톡</option>
									<option value="push">PUSH 발송</option>
									<option value="smartMsg">통합메시지 발송</option>
									<option value="rpt">리포트조회</option>
									 -->
								</select>
							</td>
						</tr>
						<tr>
							<td>callback</td>
							<td>
								<input type="text" id="callback" name="callback" class="form-control" value="1544-5992">
							</td>
						</tr>
						<tr>
							<td>campaignId</td>
							<td>
								<input type="text" id="campaignId" name="campaignId" class="form-control" value="campaignId123">
							</td>
						</tr>
						<tr>
							<td>deptCode</td>
							<td>
								<input type="text" id="deptCode" name="deptCode" class="form-control" value="deptCode123">
							</td>
						</tr>
						<tr>
							<td>msg</td>
							<td>
								<input type="text" id="msg" name="msg" class="form-control" value="SMS test..">
							</td>
						</tr>
					</tbody>
				</table>
				</div>
			</form>
			<form id="recvInfoLst" name="recvInfoLst" action="" method="post">
				<p>
				<div class="container">
					<table class="table-sm table-bordered table-hover" style="width:100%;">
					<colgroup>
						<col width="30%">
						<col width="80%">
					</colgroup>
					<tbody>
						<tr>
							<td>recvInfoLst</td>
						</tr>
						<tr>
							<td>cliKey</td>
							<td>
								<input type="text" id="cliKey" name="cliKey" class="form-control" value="test1">
							</td>
						</tr>
						<tr>
							<td>phone</td>
							<td>
								<input type="text" id="phone" name="phone" class="form-control" value="123456789">
							</td>
						</tr>
						<tr id="tr_callback">
							<td colspan="2">
								<input type="button" class="btn btn-default pull-right" id="submitBtn" name="submitBtn" value="요청"/>
							</td>
						</tr>
					</tbody>
				</table>
				</div>
			</form>
			<div class="container">
				<table class="table-sm table-bordered table-hover" style="width:100%;">
				<colgroup>
					<col width="30%">
					<col width="80%">
				</colgroup>
				<thead>
				</thead>
				<tbody>
					<tr>
						<td>결과</td>
						<td><textarea name="result" id="result" style="width:100%;border:1;overflow:visible;text-overflow:ellipsis;" rows=5></textarea></td>
					</tr>
				</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</body>
</html>