<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#checkIdResult, #checkPasswdResult, #checkPasswd2Result {
		font-size: 10px; /* 글자 크기 줄이기 */
	}

</style>
<!-- 다음 주소검색 API 사용을 위한 라이브러리 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	$(function(){
		let isDuplicateId = false; // 아이디 중복 여부 저장할 변수
		let isSamePasswd = false; // 패스워드 일치 여부 저장할 변수
		
		// 1. 아이디 입력란에서 커서가 빠져나갈 때 아이디 입력값 검증 및 ID 중복확인 수행하기 => blur 
		$("#id").blur(function() {
			let id = $("#id").val(); // 아이디 입력값 가져오기
// 			if(id == "") { // 아이디 입력값이 없을 경우 
				// => 아래의 정규표현식 검증에서도 ""인 경우 false 리턴되므로 주석 처리
// 				$("#checkIdResult").html("아이디 입력 필수!"); // 아이디 옆의 영역에 글자 출력
// 				$("#checkIdResult").css("color", "red"); // 글자 색상 바꾸기
// 			}
			
			// 아이디 입력값 검증을 위한 정규표현식 활용
			// => 영문자, 숫자, 특수문자(_) 조합 4 ~ 16(A-Za-z0-9_ 대신 \w 사용가능)
			// => 단, 첫글자에 영문자 또는 숫자만 허용하고 _ 사용 불가("_admin" : 사용 불가 아이디)
			// => c.f. \w : '_'를 포함한 단어를 구성하는 모든 요소를 뜻함
			
// 			let regex = /^[A-Za-z0-9_]{4,16}$/; 
			// => 자바스크립트에서는 "" 대신 // 사이에 조건을 넣으면 바로 정규표현식으로 인식
			// => ^[]$ : ^$ - 시작부터 끝까지 다 이 규칙 부합해야함(통째로 검증) 
			//	         [] - 요소 하나를 뜻함
			//           {최소값, 최대값} - 반복을 의미하는 중괄호
			// => 주의! 파싱해서 써야하므로 공백이 들어가면 안 됨!
			
			let regex = /^[A-Za-z0-9][\w]{3,15}$/; 
			// => 첫 자리에 _제외한 값이 들어가도록 조건을 따로 설정했으므로 {} 안의 숫자가 하나씩 줄어듦

			// 자바스크립트에서는 정규표현식을 검증할 때 정규표현식 객체의 exec() 메서드를 호출하여 
			// 검증할 문자열 전달 => true/false 리턴
// 			console.log("아이디 : " + id + ", 정규표현식 : " + regex);
			if(!regex.exec(id)) { // 입력값 검증 실패 시
				$("#checkIdResult").html("영문자, 숫자, _ 조합 8 ~ 16자리 필수!(첫글자 _ 사용 불가)"); // 아이디 아래의 영역에 글자 출력
				$("#checkIdResult").css("color", "red"); // 글자 색상 바꾸기
			} else { // 입력값 검증 성공 시
				// 아이디 중복 검사를 위한 AJAX 활용 => 페이지 이동 X
				// 요청 주소 : "MemberCheckDupId", 파라미터 : 아이디
				$.ajax({
					url: "MemberCheckDupId",
					data: {
						id: id	
					},
					dataType: "json", // 응답데이터를 JSON 객체 형식으로 전달받을 경우 지정
					success: function(checkDuplicateResult) {
// 						console.log("ID 중복 확인 결과 : " + checkDuplicateResult + ", 데이터타입 : " + typeof(checkDuplicateResult));	
						// => dataType 지정 안할 경우(기본값은 "text") String, "json"으로 지정할 경우 boolean
						// => 응답데이터 형식을 JSON 타입으로 지정했을 때, 연결된 주소에서
						//    단순 1개 데이터를 그대로 리턴받았을 경우 해당 데이터타입을 인식함
						// e.g. "true"/"false" 리턴 시 boolean 타입으로 인식하고
						//      "1", "2"로 지정 시 number 타입으로 인식
						//    -- c.f. 현재 경우 연결 주소는 위에서 지정한 url: "MemberCheckDupId"(서블릿 주소)
						//		      => MemberController의 매핑 메서드(checkDupId())에서 값을 리턴해준다)
						if(checkDuplicateResult) { // 리턴 받은 값(checkDuplicateResult)이 true인 경우 아이디 중복
							$("#checkIdResult").html("이미 사용중인 아이디!"); // 아이디 아래의 영역에 글자 출력
							$("#checkIdResult").css("color", "red"); // 글자 색상 바꾸기
							isDuplicateId = true; 
							// => 중복된 아이디가 있다는 뜻의 true를 아이디 중복 여부 저장할 변수에 저장
							// => true인 경우 아이디 중복이므로 가입(submit) 버튼 클릭 시 
							//    return false; 로 submit 동작을 취소해야한다!(아래의 8번 이벤트 처리를 통해 서술) 
						} else { // 리턴 받은 값(checkDuplicateResult)이 false인 경우 사용 가능한 아이디
							$("#checkIdResult").html("사용 가능한 아이디!"); // 아이디 아래의 영역에 글자 출력
							$("#checkIdResult").css("color", "green"); // 글자 색상 바꾸기
							isDuplicateId = false; 
							// => 중복된 아이디가 없다는 뜻의 false를 아이디 중복 여부 저장할 변수에 저장
						}
						
					}
					// 실패 처리는 없는 걸로 치고 error 생략
				});
				
			}
			
		});
		
		

		
		// 2. 비밀번호 입력란에서 커서 빠져나갈 때 비밀번호 입력값 검증
		$("#passwd").blur(function() {
			let passwd = $("#passwd").val();
			
			// 입력값 검증(복잡도(안전도) 검사 포함)
			// 공통으로 사용할 메시지 입력값, 글자색 변수 선언(기본값 널스트링)
			let msg = "";
			let color = "";
			
			// 1) 비밀번호 길이 검증 : 영문자(대소문자), 숫자, 특수문자(!@#$%) 조합 8 ~ 16자리 
			let lengthRegex = /^[A-Za-z0-9!@#$%]{8,16}$/;
			
			if(!lengthRegex.exec(passwd)) { // 패스워드 길이 체크 위반
				msg = "영문자(대소문자), 숫자, 특수문자(!@#$%) 조합 8 ~ 16자리 필수!";
				color = "red";
			} else {
				// 2) 패스워드 복잡도 검사(영문 대소문자, 숫자, 특수문자 중 최소 2가지 조합)
				//    단, 부분 검사를 수행하므로 시작(^)과 끝($) 표기X, 
				//    요소 하나하나에 대한 검증이므로 반복 필요 없으므로 중괄호 X
				// 2-1) 영문자 대문자 검사 규칙
				let engUpperRegex = /[A-Z]/;
				// 2-2) 영문자 소문자 검사 규칙
				let engLowerRegex = /[a-z]/;
				// 2-3) 숫자 검사 규칙
				let numRegex = /[\d]/; // [0-9] 와 동일
				// 2-4) 특수문자(!@#$%) 검사 규칙
				let specRegex = /[!@#$%]/;
				
				// 부분 검사를 통해 일치하는 항목 카운팅 변수 선언(일치할 경우 1씩 증가)
				let count = 0; // 기본값 0
				
				if(engUpperRegex.exec(passwd)) count++; // 패스워드 대문자 포함 시
				if(engLowerRegex.exec(passwd)) count++; // 패스워드 소문자 포함 시
				if(numRegex.exec(passwd)) count++; // 패스워드 숫자 포함 시
				if(specRegex.exec(passwd)) count++; // 패스워드 특수문자 포함 시

// 				if(engUpperRegex.exec(passwd)) {  
// 					count++;
// 				}
// 				if(engLowerRegex.exec(passwd)) { 
// 					count++;
// 				}
// 				if(numRegex.exec(passwd)) { 
// 					count++;
// 				}
// 				if(specRegex.exec(passwd)) { 
// 					count++;
// 				}
				//으로 써도 된다
				
				
				
				// 복잡도 검사 결과 판별
				// 4점 : 안전(초록), 3점 : 보통(노랑), 2점 : 위험(주황),
				// 1점 이하 : 사용불가능한 패스워드(빨강)
				switch(count) {
					case 4 :
						msg = "안전";
						color = "green";
						break;
					case 3 : 
						msg = "보통";
						color = "yellow";
						break;
						
					case 2 : 
						msg = "위험";
						color = "orange";
						break;
					case 1 : // 1점과 0점은 공통 처리를 위해 break문 없이 
					case 0 : // 중복 항목들 중 마지막 case 문에서 중복 처리 기술(default 포함 가능)
						msg = "사용 불가능한 패스워드!";
						color = "red";
				}				
				
			}
				$("#checkPasswdResult").html(msg); // 패스워드 아래의 영역에 글자 출력
				$("#checkPasswdResult").css("color", color); // 글자 색상 바꾸기
			
		});
		
// ******************* 숙제!!! jquery로 바꿔보는 연습!	
		
		// 4. 비밀번호확인 입력란에 키를 누를때마다 비밀번호와 같은지 체크하기
		document.joinForm.passwd2.onkeyup = function() {
			let passwd = document.joinForm.passwd.value;
			let passwd2 = document.joinForm.passwd2.value;
			
			// 비밀번호와 비밀번호확인 입력 내용이 같으면 "비밀번호 일치"(파란색) 표시,
   			// 아니면, "비밀번호 불일치"(빨간색) 표시
		    if(passwd == passwd2) { // 일치
		     	document.querySelector("#checkPasswd2Result").innerText = "비밀번호 일치";
		     	document.querySelector("#checkPasswd2Result").style.color = "blue";
		     	// 일치 여부를 저장하는 변수 isSamePasswd 값을 true 로 변경
		     	isSamePasswd = true;
		    } else { // 불일치
		     	document.querySelector("#checkPasswd2Result").innerText = "비밀번호 불일치";
		     	document.querySelector("#checkPasswd2Result").style.color = "red";
		     	// 일치 여부를 저장하는 변수 isSamePasswd 값을 true 로 변경
		     	isSamePasswd = false;
		    }
			
		};
		
		// 5. 주민번호 숫자 입력할때마다 길이 체크하기
		// => 주민번호 앞자리 입력란에 입력된 숫자가 6자리이면 뒷자리 입력란으로 커서 이동시키기
		// => 주민번호 뒷자리 입력란에 입력된 숫자가 7자리이면 뒷자리 입력란에서 커서 제거하기
		document.joinForm.jumin1.onkeyup = function() {
		    if(document.joinForm.jumin1.value.length == 6) {
		    	document.joinForm.jumin2.focus();
		    }
		};
		
		document.joinForm.jumin2.onkeyup = function() {
		    if(document.joinForm.jumin2.value.length == 7) {
		    	document.joinForm.jumin2.blur();
		    }
		};
		
		// 6. 이메일 도메인 선택 셀렉트 박스 항목 변경 시 = change
		//    선택된 셀렉트 박스 값을 이메일 두번째 항목(@ 기호 뒤)에 표시하기
		document.joinForm.emailDomain.onchange = function() {
			document.joinForm.email2.value = document.joinForm.emailDomain.value;
			
			// 단, 직접입력 선택 시 표시된 도메인 삭제하기
		    // 또한, "직접입력" 항목 외의 도메인 선택 시 도메인 입력창을 잠금처리 및 회색으로 변경하고,
		    // "직접입력" 항목 선택 시 도메인 입력창에 커서 요청 및 잠금 해제
		    if(document.joinForm.emailDomain.value == "") { // 직접 입력 선택 시
		    	document.joinForm.email2.focus(); // 포커스 요청
		    	document.joinForm.email2.readOnly = false; // 입력창 잠금 해제(readonly 아님!)
		    	document.joinForm.email2.style.background = "";
		    } else { // 도메인 선택 시
		    	document.joinForm.email2.readOnly = true; // 입력창 잠금 해제
		    	document.joinForm.email2.style.background = "lightgray";
		    }
		};
		
		// 7. 취미의 "전체선택" 체크박스 체크 시 취미 항목 모두 체크, 
		//    "전체선택" 해제 시 취미 항목 모두 체크 해제하기
		document.querySelector("#checkAllHobby").onclick = function() {
			for(let i = 0; i < document.joinForm.hobby.length; i++) {
				document.joinForm.hobby[i].checked = document.querySelector("#checkAllHobby").checked;
			}
		};
		
		// 8. 가입(submit) 클릭 시 이벤트 처리를 통해
	    // 아이디 중복 검사 통과(false)와 비밀번호 2개가 일치하는지(true) 체크하고 
	    // 모든 항목이 통과했을 경우에만 submit 동작이 수행되도록 처리
	    $("form").submit(function() {
	    	if(isDuplicateId) { // 아이디 중복인 경우
	    		alert("아이디를 확인해 주세요!");
	    		$("#id").focus();
	    		return false; // submit 동작 취소
	    	} else if(!isSamePasswd) {
	    		alert("패스워드를 확인해 주세요!");
	    		$("#passwd").focus();
	    		return false; // submit 동작 취소
	    		
	    	}
	    });
	    
		// =====================================================================
		// 주소 검색 API 활용 기능 추가
		// "t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" 스크립트 파일 로딩 필수!
		document.querySelector("#btnSearchAddress").onclick = function() {
			new daum.Postcode({
				// 주소검색 창에서 주소 검색 후 검색된 주소를 클릭하면
				// oncomplete: 뒤의 익명함수가 실행(호출)됨 => callback(콜백) 함수라고 함
		        oncomplete: function(data) {
		        	// 클릭(선택)된 주소에 대한 정보(객체)가 익명함수 파라미터 data 에 전달됨
					// => data.xxx 형식으로 각 주소 정보에 접근
					// 1) 우편번호(zonecode) 가져와서 우편번호 항목(post_code)에 출력
					document.joinForm.post_code.value = data.zonecode; 
					
					// 2) 기본주소(address) 가져와서 기본주소 항목(address1)에 출력
// 					document.joinForm.address1.value = data.address;
					let address = data.address;
					
					// 만약, 건물명(buildingName)이 존재(널스트링이 아님)할 경우
					// 기본주소 뒤에 건물명을 결합
					if(data.buildingName != "") {
						address += " (" + data.buildingName + ")";
					}
					
					document.joinForm.address1.value = address;
					
					// 3) 상세주소 항목(address2)에 포커스(커서) 요청
					document.joinForm.address2.focus();
		        }
		    }).open();
		};
		
		
		// c.f. 이메일 발송 처리 과정은 지금처럼 파일 내부에서 할 경우 소스코드 보기로 노출되므로 외부 js 파일로 빼는게 좋음
		let clickCnt = 0;
		$("h1").eq(0).dblclick(function() {
			clickCnt++;
			console.log(clickCnt);
			
			if(clickCnt == 5) {
				let target = "TestAuthMail?id=" + $("#id").val() + "&email=" + $("#email1").val() + "@" + $("#email2").val();
				$("#command_area").append(
						"<input type='button' value='메일발송테스트' onclick='location.href=\"" + target + "\"'>"
				);
			}
		});
		
	}); // document.ready 이벤트 끝
</script>
</head>
<body>
	<header>
		<!-- inc/top.jsp 페이지 삽입 -->
		<!-- JSP 파일 삽입 대상은 현재 파일을 기준으로 상대주소 지정 -->
		<!-- webapp 디렉토리를 가리키려면 최상위(루트) 경로 활용 -->
		<jsp:include page="../inc/top.jsp"></jsp:include>
	</header>
	<article>
		<h1>회원 가입</h1>
		<form action="MemberJoinPro" method="post" name="joinForm">
			<table border="1">
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" required></td>
				</tr>
				<tr>
					<th>아이디</th>
					<td>
						<input type="text" name="id" id="id" placeholder="8 ~ 16글자" required>
						<div id="checkIdResult"></div>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="passwd" id="passwd" placeholder="8 ~ 16글자" required>
						<div id="checkPasswdResult"></div>
					</td>
				</tr>
				<tr>
					<th>비밀번호확인</th>
					<td>
						<input type="password" name="passwd2" id="passwd2" required>
						<div id="checkPasswd2Result"></div>
					</td>
				</tr>
				<tr>
					<th>주민번호</th>
					<td>
						<!-- 입력 문자 갯수 제한 시 maxLength 속성 지정 -->
						<input type="text" name="jumin1" size="8" maxlength="6" required> -
						<input type="text" name="jumin2" size="8" maxlength="7" required>
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td>
						<input type="text" name="post_code" id="postCode" size="6" required>
						<input type="button" id="btnSearchAddress" value="주소검색">
						<br>
						<input type="text" name="address1" id="address1" size="25" placeholder="기본주소" required>
						<br>
						<input type="text" name="address2" id="address2" size="25" placeholder="상세주소" required>
					</td>
				</tr>
				<tr>
					<th>E-Mail</th>
					<td>
						<input type="text" name="email1" id="email1" size="8" required> @
						<input type="text" name="email2" id="email2" size="8" required>
						<select name="emailDomain">
							<option value="">직접입력</option>
							<option value="naver.com">naver.com</option>
							<option value="gmail.com">gmail.com</option>
							<option value="nate.com">nate.com</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>직업</th>
					<td>
						<select name="job" required>
							<option value="">항목을 선택하세요</option>
							<option value="개발자">개발자</option>
							<option value="DB엔지니어">DB엔지니어</option>
							<option value="서버엔지니어">서버엔지니어</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<input type="radio" name="gender" value="남" required>남
						<input type="radio" name="gender" value="여" required>여
					</td>
				</tr>
				<tr>
					<th>취미</th>
					<td>
						<input type="checkbox" name="hobby" value="여행">여행
						<input type="checkbox" name="hobby" value="독서">독서
						<input type="checkbox" name="hobby" value="게임">게임
						<input type="checkbox" id="checkAllHobby" value="전체선택">전체선택
					</td>
				</tr>
				<tr>
					<th>가입동기</th>
					<td>
						<textarea rows="5" cols="40" name="motivation" required></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" id="command_area">
						<input type="submit" value="가입">
						<input type="reset" value="초기화">
						<input type="button" value="돌아가기">
					</td>
				</tr>
			</table>
		</form>
	</article>
	<footer>
	
	</footer>
</body>
</html>