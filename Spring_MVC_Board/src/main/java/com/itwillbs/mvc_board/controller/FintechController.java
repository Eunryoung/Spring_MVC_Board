package com.itwillbs.mvc_board.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.mvc_board.service.BankService;
import com.itwillbs.mvc_board.vo.ResponseTokenVO;
import com.itwillbs.mvc_board.vo.ResponseUserInfoVO;


@Controller
public class FintechController {
	
	@Autowired
	private BankService bankService; // alt + shift + R -> 변수명 한번에 변경
	
	// 로그 출력을 위한 기본 라이브러리(org.slf4j.Logger 타입) 변수 선언
	// => org.slf4j.LoggerFactory.getLogger() 메서드 호출하여 Logger 객체 리턴받아 사용 가능
	//    파라미터 : 로그를 사용하여 다룰 현재 클래스 지정(해당 클래스에서 발생한 로그로 처리)
	private static final Logger logger = LoggerFactory.getLogger(FintechController.class);
	// => Logger 객체의 다양한 로그 출력 메서드(info, debug, warn, error 등) 활용하여 로그 출력 가능
	//    (각 메서드는 로그의 심각도(레벨)에 따라 구별하는 용도로 사용)
	// -------------------------------------------------------------------------
	// "/FintechMain" 매핑 => fintech/main.jsp 페이지 포워딩
	@GetMapping("FintechMain")
	public String FintechMain(HttpSession session, Model model) {
		// 세션 아이디 없을 경우 "로그인이 필요합니다" 처리를 위해 "forward.jsp" 페이지 포워딩
		if(session.getAttribute("sId") == null) {
			model.addAttribute("msg", "로그인이 필요합니다!");
			// targetURL 속성명으로 로그인 폼 페이지 서블릿 주소 저장
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		}
		
		// 랜덤값을 활용하여 32바이트 난수 생성 후 메인페이지로 전달 및 세션에 저장 후 메인페이지로 포워딩
		String rNum = RandomStringUtils.randomNumeric(32); // 리턴타입 전부 String이므로 문자열 타입 변수에 저장
		logger.info("생성된 난수 : " + rNum);
		
//		model.addAttribute("state", rNum); // 세션에 어차피 넘어가므로 모델은 굳이 필요 없음
		// => c.f. 모델에 주고 세션에 안 준다면 새로고침하면 날아감
		//         세션은 로그아웃할때까지 남아있어서 사용 후에  날려야함
		session.setAttribute("state", rNum);
		
		return "fintech/main";
	}
	
	@GetMapping("callback") // 기본 get매핑
	public String callback(@RequestParam Map<String, String> authResponse, HttpSession session, Model model) {
		// 콜백을 통해 전달되는 응답 데이터 3가지(code, scope, client_info) 파라미터 값이
		// Map 객체에 자동으로 저장됨
		logger.info("authResponse : " + authResponse.toString()); // syso 아니므로 toString() 붙여야함
		
		// ----------------------------------------------------
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			// "fail_back.jsp" 페이지로 포워딩 시 "isClose" 값을 true 로 설정하여 전달
			model.addAttribute("msg", "로그인이 필요합니다!");
			model.addAttribute("isClose", true); // 현재 창(서브 윈도우) 닫도록 명령
			return "fail_back";
		}
		
		
		// ----------------------------------------------------
		// 응답 데이터 중 state 값이 요청 시 사용된 값인지 판별
		if(session.getAttribute("state") == null || !session.getAttribute("state").equals(authResponse.get("state"))) { 
			// 세션의 state 값이 null이거나 세션의 state 값과 응답 데이터의 state 값이 다를 경우
			
			// "잘못된 요청입니다!" 출력 후 이전페이지로 돌아가기
			model.addAttribute("msg", "잘못된 요청입니다!");
			return "fail_back";
		} // else는 필요없음(애초에 없거나 다른 경우로 판별했으니 authResponse.get("state")의 길이가 0인 경우 등의 다른 요청은 검사 필요 안해도 될듯)
		
		// 확인 완료된 세션의 state 값 삭제
		session.removeAttribute("state"); // invalidate() 메서드 호출 아님!!!!
		System.out.println("삭제된 세션의 state값 확인 : " + session.getAttribute("state"));
		
		
		// ----------------------------------------------------
		// 2.1.2. 토큰발급 API - 사용자 토큰 발급 API 요청
		// BankApiService - requestAccessToken() 메서드 호출
		// => 파라미터 : 토큰 발급 요청에 필요한 정보(인증코드 요청 결과 Map 객체)
		//    리턴타입 : ResponseTokenVO(responseToken)
		ResponseTokenVO responseToken = bankService.requestAccessToken(authResponse);
		System.out.println("리턴받은 액세스 토큰 정보 : " + responseToken); 
		// 새로고침할 경우
		// => 리턴받은 액세스 토큰 정보 : ResponseTokenVO(access_token=null, token_type=null, expires_in=null, refresh_token=null, scope=null, user_seq_no=null)
		// 인증 실패했든 코드 발급받고 일정 시간 지나면 코드값 만료한 경우든 객체 자체는 있으나 값이 null이 됨
		
		// ResponseTokenVO 객체가 null 이거나 엑세스토큰 값이 null 일 경우 에러 처리
		// "forward.jsp" 페이지로 포워딩 시 "isClose" 값을 true 로 설정하여 전달
		//  (현재 새 창 띄우는 방식이므로 인증 실패할 경우 창 닫음 처리)
		// => state 값 갱신 위해 "FintechMain" 서블릿 주소 설정
		if(responseToken == null || responseToken.getAccess_token() == null) {
			model.addAttribute("msg", "토큰 발급 실패! 다시 인증하세요!");
			model.addAttribute("isClose", true);
			model.addAttribute("targetURL", "FintechMain");
			return "forward";
		}
		
		// BankApiService - registAccessToken() 메서드 호출하여 토큰 관련 정보 저장 요청
		// => 파라미터 : 세션 아이디, ResponseTokenVO 객체
		// => 만약, 하나의 객체로 전달할 경우(Map 객체 활용)
//		bankApiService.registAccessToken(id, responseToken);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("token", responseToken);
		bankService.registAccessToken(map);
		
		// 세션 객체에 엑세스 토큰(access_token), 사용자번호(user_seq_no) 저장
		// => db에 저장해놓고 써도 되지만 요청할 때마다 써야하므로 세션에 저장할 것임
		session.setAttribute("access_token", responseToken.getAccess_token());
		session.setAttribute("user_seq_no", responseToken.getUser_seq_no());
		
		// "forward.jsp" 페이지 포워딩을 통해
		// "계좌 인증 완료" 메세지 출력 후 인증 창 닫고 FintechUserInfo 서블릿 요청
		model.addAttribute("msg", "계좌 인증 완료!");
		model.addAttribute("isClose", true);
		model.addAttribute("targetURL", "FintechUserInfo");
		
		return "forward";
	}
	
	// 2.2.1. 사용자정보조회 API
	@GetMapping("FintechUserInfo")
	public String requestUserInfo(HttpSession session, Model model) {
		// 세션아이디가 null 일 경우 로그인 페이지 이동 처리
		// 엑세스토큰이 null 일 경우 "계좌 인증 필수!" 메세지 출력 후 "forward.jsp" 페이지 포워딩
		if(session.getAttribute("sId") == null) {
			model.addAttribute("msg", "로그인 필수!");
//			model.addAttribute("isClose", true); // 새 창이 아니므로 창 닫기 불필요
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		} else if(session.getAttribute("access_token") == null) {
			model.addAttribute("msg", "계좌 인증 필수!");
//			model.addAttribute("isClose", true); // 새 창이 아니므로 창 닫기 불필요
			model.addAttribute("targetURL", "FintechMain");
			return "forward";
		}
		
		// Map 객체에 세션에 저장된 엑세스 토큰(access_token)과 사용자번호(user_seq_no) 저장
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("access_token", session.getAttribute("access_token"));
//		map.put("user_seq_no", session.getAttribute("user_seq_no"));
		Map<String, String> map = new HashMap<String, String>();
		map.put("access_token", (String)session.getAttribute("access_token"));
		map.put("user_seq_no", (String)session.getAttribute("user_seq_no"));
		// => Map 객체의 제네릭 타입을 String, Object 로 사용해도 무관(세션값 형변환 불필요)
		
		
		// 2.2. 사용자/서비스 관리 - 2.2.1. 사용자정보조회 API 요청
		// BankService - requestUserInfo() 메서드 호출하여 핀테크 사용자 정보조회 요청
		// => 파라미터 : Map 객체   리턴타입 : ResponseUserInfoVO(userInfo) 
//		ResponseUserInfoVO userInfo = bankService.requestUserInfo(map);
		Map<String, Object> userInfo = bankService.requestUserInfo(map);
		logger.info(">>>>>>>>>>>>>>>>>>> userInfo : " + userInfo);
		// >>>>>>>>>>>>>>>>>>> userInfo : ResponseUserInfoVO(api_tran_id=527c3675-a0bf-4ba4-a752-fd9cba8f5deb, api_tran_dtm=20240122152855178, rsp_code=A0000, rsp_message=, user_seq_no=1101043342, user_ci=/6Yqr3S4R18cm4DyfTN6PGXiLTE4RsjYuV6pf/nrFgiSc8PweAZcyt28GYm+Nb/ZNaS3BKbqVz/aZTQ0WUqh3Q==, user_name=임은령, user_info=null, user_gender=null, user_cell_no=null, user_email=null, res_cnt=1, res_list=[BankAccountVO(fintech_use_num=120211385488932395653894, account_alias=임은령테스트, bank_code_std=002, bank_code_sub=0000000, bank_name=KDB산업은행, savings_bank_name=, account_num=null, account_num_masked=20230821***, account_seq=, account_holder_name=임은령, account_holder_type=P, inquiry_agree_yn=Y, inquiry_agree_dtime=20240122123648, transfer_agree_yn=Y, transfer_agree_dtime=20240122123648)])
		// => rsp_code=A0000 들어있으면 성공
		
		// Model 객체에 ResponseUserInfo 객체 저장
		model.addAttribute("userInfo", userInfo);
		
		return "fintech/fintech_user_info";
	}
	
	// 2.3.1. 잔액조회 API
	@PostMapping("BankAccountDetail")
	public String accountDetail(@RequestParam Map<String, String> map, HttpSession session, Model model) {
//	public String accountDetail(Map<String, String> map, HttpSession session, Model model) {
		
		System.out.println("파라미터로 넘어온 값 확인 : " + map);
		System.out.println("user_name 확인 : " + map.get("user_name")); // null
		// 세션아이디가 null 일 경우 로그인 페이지 이동 처리
		// 엑세스토큰이 null 일 경우 "계좌 인증 필수!" 메세지 출력 후 "forward.jsp" 페이지 포워딩
		if(session.getAttribute("sId") == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		} else if(session.getAttribute("access_token") == null) {
			model.addAttribute("msg", "계좌 인증 필수!");
			model.addAttribute("targetURL", "FintechMain");
			return "forward";
		}
		
		// 요청에 사용할 엑세스토큰(세션)을 Map 객체에 추가
		map.put("access_token", (String)session.getAttribute("access_token"));
		
		// BankService - requestAccountDetail() 메서드 호출하여 계좌 상세정보 조회 요청
		// => 파라미터 : Map 객체   리턴타입 : Map<String, Object>(accountDetail)
		Map<String, Object> accountDetail = bankService.requestAccountDetail(map);
		
		
		// 조회결과(Map 객체, 이름, 계좌번호) 저장
		model.addAttribute("accountDetail", accountDetail);
		model.addAttribute("user_name", map.get("user_name"));
//		model.addAttribute("user_name", map.get("account_holder_name"));
		model.addAttribute("account_num_masked", map.get("account_num_masked"));
		
		return "fintech/fintech_account_detail";
		
	}
	
	
	// 2.5.1. 출금이체 API
	@PostMapping("BankPayment")
	public String bankPayment(@RequestParam Map<String, String> map, HttpSession session, Model model) {
		
//		logger.info(">>>>>>>>>>>>>>>>> payment : " + map);
		// >>>>>>>>>>>>>>>>> payment : {fintech_use_num=120211385488932395653894, req_client_name=임은령, tran_amt=15000}

		String id = (String)session.getAttribute("sId");
		// 세션아이디가 null 일 경우 로그인 페이지 이동 처리
		// 엑세스토큰이 null 일 경우 "계좌 인증 필수!" 메세지 출력 후 "forward.jsp" 페이지 포워딩
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		} else if(session.getAttribute("access_token") == null) {
			model.addAttribute("msg", "계좌 인증 필수!");
			model.addAttribute("targetURL", "FintechMain");
			return "forward";
		}
		
		// 요청에 필요한 엑세스토큰과 세션 아이디를 Map 객체에 추가
		map.put("access_token", (String)session.getAttribute("access_token"));
		map.put("id", id);
		
		// BankService - requestWithdraw() 메서드 호출하여 상품 구매에 대한 지불(출금이체) 요청
		// => 파라미터 : Map 객체   리턴타입 : Map<String, Object>(withdrawResult)
		Map<String, Object> withdrawResult = bankService.requestWithdraw(map);
		logger.info(">>>>>>>>>>>>>>>>>>지불 요청 결과(withdrawResult) : " + withdrawResult);
		// >>>>>>>>>>>>>>>>>>지불 요청 결과(withdrawResult) 
		// : {api_tran_id=45357965-dbcb-426b-965a-63b93820e3e3, rsp_code=A0322, rsp_message=미등록된 이용기관 약정 계좌/계정 [입력 정보(23062003999)], api_tran_dtm=20240124121711919}
		// => 23062003999 이 번호를 입력했는데 테스트데이터에 등록이 안 되어있다는 소리임
		//    c.f. 등록은 마이페이지 약정계좌관리 입/출금계좌정보에서 가능 -> 다같이 등록할거니까 저장할때는 타이밍 맞춰서 푸시해야함
		// => "출금"해서 아이티윌에 넣을거니까 마이페이지 약정계좌관리 "출금"계좌정보에 등록  
		//    (c.f. 강사님 "입금" 계좌 정보 등록 이후에는 똑같은 메시지 나옴)
		
		
		// 강사님 "출금"계좌 정보 등록 이후 메시지
		// >>>>>>>>>>>>>>>>>>지불 요청 결과(withdrawResult)
		// : {api_tran_id=710d03b2-ffde-40de-ae19-34dab77be6b9, rsp_code=A0004, rsp_message=요청전문 포맷 에러 [최종수취고객정보가 입력되지 않았습니다.], api_tran_dtm=20240124122213006}

		// BankApiClient.java 파일에서 "recv_client_name", "recv_client_bank_code", "recv_client_account_num" 세가지 항목을 
		// JSONObject에 put 메서드로 설정 이후 메시지 
		// >>>>>>>>>>>>>>>>>>지불 요청 결과(withdrawResult) 
		// : {api_tran_id=01707e85-470d-4bbf-87c9-6c7b26b8dc30, rsp_code=A0002, rsp_message=참가기관 에러 [API업무처리시스템 - 시뮬레이터 응답전문 존재하지 않음], api_tran_dtm=20240124122518590, dps_bank_code_std=002, dps_bank_code_sub=0000000, dps_bank_name=KDB산업은행, dps_account_num_masked=, dps_print_content=admin, dps_account_holder_name=, bank_tran_id=M202113854UIZVR5HKXZ, bank_tran_date=20240124, bank_code_tran=098, bank_rsp_code=818, bank_rsp_message=시뮬레이터　응답전문　조회에　실패하였습니다, fintech_use_num=120211385488932395653894, account_alias=, bank_code_std=002, bank_code_sub=0000000, bank_name=KDB산업은행, account_num_masked=, print_content=적요내용입니다, tran_amt=15000, account_holder_name=, wd_limit_remain_amt=, savings_bank_name=}

		// 이제 테스트 데이터 등록할거임
		// 마이페이지 - 테스트 정보 관리 - 응답정보관리 - 출금이체 에서 등록(BankApiClient.java 파일 참고)
		// 테스트 데이터 등록 이후 메시지
		// >>>>>>>>>>>>>>>>>>지불 요청 결과(withdrawResult)
		// : {api_tran_id=ee622e19-6a14-4074-b774-390ec1b2f4c0, rsp_code=A0000, rsp_message=, api_tran_dtm=20240124123448183, dps_bank_code_std=097, dps_bank_code_sub=0000000, dps_bank_name=오픈은행, dps_account_num_masked=9876543210987***, dps_print_content=admin, dps_account_holder_name=이연태, bank_tran_id=M202113854UXAPFH0CED, bank_tran_date=20190101, bank_code_tran=097, bank_rsp_code=000, bank_rsp_message=, fintech_use_num=120211385488932395653894, account_alias=임은령테스트, bank_code_std=002, bank_code_sub=0970001, bank_name=KDB산업은행, account_num_masked=20230821***, print_content=통장기재내용, tran_amt=15000, account_holder_name=임은령, wd_limit_remain_amt=9985000, savings_bank_name=}
		// 한번 더 새로고침하면 wd_limit_remain_amt이 바뀜
		// wd_limit_remain_amt=9985000 -> wd_limit_remain_amt=9970000


		
		
		// 요청 결과를 model 객체에 저장
		model.addAttribute("withdrawResult", withdrawResult);
		
		return "fintech/fintech_payment_result";
	}
	
	
	// =============================================================================
	// 입금이체는 이용기관(ex. 아이티윌)의 계좌에서 사용자의 계좌로 자금이 이동하므로
	// 이용기관의 계좌에 접근 가능한 엑세스토큰 필요하다.
	// 또한, 입금이체를 위해서는 별도로 oob 권한이 있는 엑세스토큰 발급 필요하다.
	// 2.1.2. 토큰발급 API - 센터인증 이용기관 토큰발급 API (2-legged)
	@GetMapping("FintechAdminAccessToken")
	public String bankAdminAccessToken(HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 세션아이디가 null 일 경우 로그인 페이지 이동 처리
		// 관리자가 아닐 경우 "잘못된 접근입니다!" 처리
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		} else if(!id.equals("admin")) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			model.addAttribute("targetURL", "./");
			return "forward";
		} 
		
		// BankService - requestAdminAccessToken() 메서드 호출하여 관리자 엑세스토큰 발급 요청
		// => 파라미터 : 없음   리턴타입 : ResponseTokenVO(responseAdminAccessToken)
		ResponseTokenVO responseToken = bankService.requestAdminAccessToken();
		System.out.println(">>>>>>> 관리자 엑세스토큰 : " + responseToken);
		
		
		// refresh_token 과 user_seq_no 값은 널스트링("")으로 설정
		responseToken.setRefresh_token("");
		responseToken.setUser_seq_no("");
		
		// BankApiService - registAccessToken() 메서드 호출하여 토큰 관련 정보 저장 요청
		// => 파라미터 : 세션 아이디, ResponseTokenVO 객체
		// => 만약, 하나의 객체로 전달할 경우(Map 객체 활용)
//		bankApiService.registAccessToken(id, responseToken);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		map.put("token", responseToken);
		bankService.registAccessToken(map);
		
		model.addAttribute("msg", "토큰 발급 완료!");
		model.addAttribute("targetURL", "FintechMain");
		return "forward";
	}
	// =============================================================================
	
	
	// 2.5.2. 입금이체 API
	@PostMapping("BankRefund")
	public String bankRefund(@RequestParam Map<String, String> map, HttpSession session, Model model) {
//		logger.info(">>>>> payment : " + map);
		
		String id = (String)session.getAttribute("sId");
		// 세션아이디가 null 일 경우 로그인 페이지 이동 처리
		// 엑세스토큰이 null 일 경우 "계좌 인증 필수!" 메세지 출력 후 "forward.jsp" 페이지 포워딩
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
//					model.addAttribute("isClose", true); // 새 창이 아니므로 창 닫기 불필요
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		} else if(session.getAttribute("access_token") == null) {
			model.addAttribute("msg", "계좌 인증 필수!");
//					model.addAttribute("isClose", true); // 새 창이 아니므로 창 닫기 불필요
			model.addAttribute("targetURL", "FintechMain");
			return "forward";
		}
		
//		map.put("access_token", (String)session.getAttribute("access_token"));
		// 요청에 필요한 엑세스토큰과 세션 아이디를 Map 객체에 추가
		// => 주의! 입금이체에 필요한 엑세스토큰은 이용기관의 엑세스토큰이므로
		//    저장된 "admin" 계정의 엑세스토큰(oob) 조회 필요
		// => BankService - getAdminAccessToken() 메서드 호출하여 관리자 엑세스토큰 조회
		map.put("access_token", bankService.getAdminAccessToken());
		map.put("id", id);
		System.out.println(">>>>>>>>>>>>>>>>>>> 입금이체 요청 데이터 : " + map);
		
		
		// BankService - requestDeposit() 메서드 호출하여 상품에 대한 환불(입금이체) 요청
		// => 파라미터 : Map 객체   리턴타입 : Map<String, Object>(depositResult)
		Map<String, Object> depositResult = bankService.requestDeposit(map);
		logger.info(">>>>>>> depositResult : " + depositResult);
		
		// 요청 결과를 model 객체에 저장
		model.addAttribute("depositResult", depositResult);
		
		return "fintech/fintech_refund_result";
	}
	
	
	// 송금(2.5.1 출금이체 API + 2.5.2. 입금이체 API)
	@PostMapping("BankTransfer")
	public String bankTransfer(@RequestParam Map<String, String> map, HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 세션아이디가 null 일 경우 로그인 페이지 이동 처리
		// 엑세스토큰이 null 일 경우 "계좌 인증 필수!" 메세지 출력 후 "forward.jsp" 페이지 포워딩
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
//					model.addAttribute("isClose", true); // 새 창이 아니므로 창 닫기 불필요
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		} else if(session.getAttribute("access_token") == null) {
			model.addAttribute("msg", "계좌 인증 필수!");
//					model.addAttribute("isClose", true); // 새 창이 아니므로 창 닫기 불필요
			model.addAttribute("targetURL", "FintechMain");
			return "forward";
		}

		// 사용자 정보
		map.put("access_token", (String)session.getAttribute("access_token"));
		map.put("id", id);

		// 관리자 정보
		map.put("admin_access_token", bankService.getAdminAccessToken());
		System.out.println(">>>>>>>>>>>>>>>>>>> 송금 데이터 : " + map);
		
		
		// BankService - requestTransfer() 메서드 호출하여 상품에 대한 환불(입금이체) 요청
		// => 파라미터 : Map 객체   리턴타입 : Map<String, Object>(transferResult)
		Map<String, Object> transferResult = bankService.requestTransfer(map);
		logger.info(">>>>>>> transferResult : " + transferResult);
		
		// 요청 결과를 model 객체에 저장
		model.addAttribute("transferResult", transferResult);
		
		return "fintech/fintech_refund_result";
		
	}
	
}
