package com.itwillbs.mvc_board.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.itwillbs.mvc_board.handler.BankApiClient;
import com.itwillbs.mvc_board.mapper.BankMapper;
import com.itwillbs.mvc_board.vo.MemberVO;
import com.itwillbs.mvc_board.vo.ResponseTokenVO;
import com.itwillbs.mvc_board.vo.ResponseUserInfoVO;

@Service
public class BankService {
 
	@Autowired
	private BankApiClient bankApiClient;

	@Autowired
	private BankMapper bankMapper;
	
	// 액세스 토큰 발급 요청
	public ResponseTokenVO requestAccessToken(Map<String, String> authResponse) {
		// BankApiClient - requestAccessToken() 메서드 호출하여 엑세스 토큰 발급 요청
		// => 리턴타입 : ResponseTokenVO
		return bankApiClient.requestAccessToken(authResponse);
	}


	// 엑세스 토큰 저장 요청
//	public void registAccessToken(String id, ResponseTokenVO responseToken) {
//		// BankMapper - insertAccessToken() 메서드 호출하여 엑세스 토큰 저장 요청
//		bankMapper.insertAccessToken(id, responseToken);
//	}


	// 엑세스 토큰 저장 요청(Map 타입 파라미터로 처리할 경우)
	public void registAccessToken(Map<String, Object> map) {
		// BankMapper - selectId() 메서드 호출하여 아이디에 해당하는 레코드 존재 여부 확인
		// => 파라미터 : Map 객체   리턴타입 : String
		String id = bankMapper.selectId(map);
		
		// 아이디 존재 여부 판별
		// 아이디 존재하지 않을 경우 : 새 엑세스 토큰 INSERT(insertAccessToken())
		// 아이디 존재할 경우 : 기존 엑세스 토큰 UPDATE(updateAccessToken())
		if(id == null) {
			bankMapper.insertAccessToken(map);
		} else {
			bankMapper.updateAccessToken(map);
		}
		
		
	}

	// 토큰 관련 정보 조회 요청
	public Map<String, String> getBankUserInfo(String id) {
		return bankMapper.selectBankUserInfo(id);
	}

	// 사용자 정보 조회 요청
//	public ResponseUserInfoVO requestUserInfo(Map<String, String> map) {
		// BankApiClient - requestUserInfo() 메서드 호출하여 사용자 정보 조회 요청
//		return bankApiClient.requestUserInfo(map);
//	}
	
	// 사용자 정보 조회 요청 - 만약, 응답데이터를 Map 타입으로 처리할 경우(Map<String, Object> 타입 사용)
	public Map<String, Object> requestUserInfo(Map<String, String> map) {
		// BankApiClient - requestUserInfo() 메서드 호출하여 사용자 정보 조회 요청
		return bankApiClient.requestUserInfo(map);
	}

	// 계좌 상세정보 조회 요청
	public Map<String, Object> requestAccountDetail(Map<String, String> map) {
		// BankApiClient - requestAccountDetail()
		return bankApiClient.requestAccountDetail(map);
	}


	// 출금 이체 요청
	public Map<String, Object> requestWithdraw(Map<String, String> map) {
		// BankApiClient - requestWithdraw()
		return bankApiClient.requestWithdraw(map);
	}

	// 관리자 엑세스토큰(oob) 발급 요청
	public ResponseTokenVO requestAdminAccessToken() {
		// BankApiClient - requestAdminAccessToken()
		return bankApiClient.requestAdminAccessToken();
	}

	// 관리자 엑세스토큰 조회 요청
	public String getAdminAccessToken() {
		// BankMapper - selectAdminAccessToken()
		return bankMapper.selectAdminAccessToken();
	}

	// 입금 이체 요청
	public Map<String, Object> requestDeposit(Map<String, String> map) {
		// BankApiClient - requestDeposit()
		return bankApiClient.requestDeposit(map);
	}

	// 송금 요청
	// 출금이체 후 해당 정보를 Map 객체에 추가하고
	// 다시 입금이체 후 해당 정보를 Map 객체에 추가하여 리턴
	public Map<String, Object> requestTransfer(Map<String, String> map) {
		Map<String, Object> transferResult = new HashMap<String, Object>();
		// BankApiClient - requestWithdraw2()
		transferResult.put("withdrawResult", bankApiClient.requestWithdraw2(map));
		// BankApiClient - requestDeposit2()
		transferResult.put("depositResult", bankApiClient.requestDeposit2(map));
		
		return transferResult;
	}
	
	
	
}
