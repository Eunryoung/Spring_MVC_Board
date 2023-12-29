package com.itwillbs.mvc_board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.mvc_board.mapper.MemberMapper;
import com.itwillbs.mvc_board.vo.MailAuthInfoVO;
import com.itwillbs.mvc_board.vo.MemberVO;

@Service
public class MemberService {
	// MemberMapper 객체 자동 주입
	@Autowired
	private MemberMapper mapper;

	// 회원가입 작업 요청
	public int registMember(MemberVO member) {
		// MemberMapper(인터페이스) - insertMember()
		// => 파라미터 : MemberVO 객체   리턴타입 : int
		return mapper.insertMember(member);
	}

	// 회원 상세정보 조회 요청
	public MemberVO getMember(MemberVO member) {
		// MemberMapper(인터페이스) - selectMember()
		// => 파라미터 : MemberVO 객체   리턴타입 : MemberVO
		return mapper.selectMember(member);
	}

	// 회원정보 수정 요청
	public int modifyMember(MemberVO member, String newPasswd) {
		// MemberMapper - updateMember()
		return mapper.updateMember(member, newPasswd);
	}

	// 회원 탈퇴 요청
	public int withdrawMember(MemberVO member) {
		// MemberMapper - updateWithdrawMember()
		return mapper.updateWithdrawMember(member);
	}

	// ====================================================
	// 관리자
	// 회원 목록 조회 요청
	public List<MemberVO> getMemberList() {
		// MemberMapper - selectMemberList()
		return mapper.selectMemberList();
	}

	// 메일 인증 정보 등록 요청
	public void registMailAuthInfo(String id, String auth_code) {
		// 기존 인증정보 존재 여부 확인을 위해 인증정보 조회 수행
		// MemberMapper - selectMailAuthInfo() 메서드 호출
		// => 파라미터 : 아이디, 인증코드   리턴타입 : MailAuthInfoVO
		MailAuthInfoVO authInfo = mapper.selectMailAuthInfo(id);
		System.out.println("authInfo : " + authInfo);
		
		// 기존 인증 정보 존재 여부 판별
		if(authInfo == null) { // 기존 인증정보 존재하지 않을 경우 => 새 인증정보 추가(INSERT)
			// MemberMapper - insertMailAuthInfo() 메서드 호출하여 새 인증정보 추가
			// => 파라미터 : 아이디, 인증코드
			mapper.insertMailAuthInfo(id, auth_code);
		} else { // 기존 인증정보 존재할 경우 => 기존 인증정보 갱신(UPDATE)
			// MemberMapper - updateMailAuthInfo() 메서드 호출하여 기존 인증정보 갱신
			// => 파라미터 : 아이디, 인증코드
			mapper.updateMailAuthInfo(id, auth_code);
		}
		
	}

	// 메일 인증 수행 요청 => 트랜잭션 처리 필요
	@Transactional
	public boolean requestEmailAuth(MailAuthInfoVO authInfo) {
		boolean isAuthSuccess = false;
		
		// MemberMapper - selectMailAuthInfo() 메서드 호출(재사용)
		// => 파라미터 : 아이디   리턴타입 : MailAuthInfoVO(currentAuthInfo)
		MailAuthInfoVO currentAuthInfo = mapper.selectMailAuthInfo(authInfo.getId());
//		System.out.println("전달받은 인증정보 : " + authInfo);
//		System.out.println("조회된 기존 인증정보 : " + currentAuthInfo);
		
		// 조회된 인증 정보 존재 여부 판별
		if(currentAuthInfo != null) { // 존재할 경우(아이디에 해당하는 인증 정보 존재)
			// 인증메일 하이퍼링크를 통해 전달받은 인증코드와 조회된 인증코드 문자열 비교
			if(authInfo.getAuth_code().equals(currentAuthInfo.getAuth_code())) {
				// 1. MemberMapper - updateMailAuthStatus() 메서드 호출하여
				//    member 테이블의 인증상태(mail_auth_status) 값을 "Y" 로 변경
				//    => 파라미터 : 아이디
				mapper.updateMailAuthStatus(authInfo.getId());
				
				// 2. MemberMapper - deleteMailAuthInfo() 메서드 호출하여
				//    mail_auth_info 테이블의 레코드 삭제
				//    => 파라미터 : 아이디
				mapper.deleteMailAuthInfo(authInfo.getId());
				
				// 인증 수행 결과를 true 로 변경
				return true;
			}
		}
		
		return isAuthSuccess;
	}


}













