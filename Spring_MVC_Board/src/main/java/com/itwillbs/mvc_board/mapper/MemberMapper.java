package com.itwillbs.mvc_board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.mvc_board.vo.MailAuthInfoVO;
import com.itwillbs.mvc_board.vo.MemberVO;

@Mapper
public interface MemberMapper {

	// 회원 가입
	int insertMember(MemberVO member);

	// 회원 상세정보 조회
	MemberVO selectMember(MemberVO member);

	// 회원정보 수정
	// => 주의! 파라미터가 복수개일 경우 @Param 어노테이션 사용하여 파라미터 이름 지정 필수!
	int updateMember(@Param("member") MemberVO member, @Param("newPasswd") String newPasswd);

	// 회원 탈퇴
	int updateWithdrawMember(MemberVO member);

	// 메일 인증정보 조회
	MailAuthInfoVO selectMailAuthInfo(String id);
	// 새 인증정보 등록
	void insertMailAuthInfo(@Param("id") String id, @Param("auth_code") String auth_code);
	// 기존 인증정보 갱신
	void updateMailAuthInfo(@Param("id") String id, @Param("auth_code") String auth_code);
	// 회원 메일 인증상태 변경
	void updateMailAuthStatus(String id);
	// 기존 인증정보 삭제
	void deleteMailAuthInfo(String id);
	// ====================================================
	// 관리자
	// 회원 목록 조회 요청
	List<MemberVO> selectMemberList();



}












