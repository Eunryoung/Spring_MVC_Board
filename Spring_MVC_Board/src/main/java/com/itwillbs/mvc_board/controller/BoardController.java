package com.itwillbs.mvc_board.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.mvc_board.service.BoardService;
import com.itwillbs.mvc_board.vo.BoardVO;
import com.itwillbs.mvc_board.vo.PageInfo;

@Controller
public class BoardController {
	@Autowired
	private BoardService service;
	
	
	// ================================================================================
	// [ 글쓰기 ]
	// "BoardWriteForm" 서블릿 요청에 대한 글쓰기 폼 표시
	@GetMapping("BoardWriteForm")
	public String writeForm(HttpSession session, Model model) {
		// 세션 아이디 없을 경우 "로그인이 필요합니다" 처리를 위해 "forward.jsp" 페이지 포워딩
		if(session.getAttribute("sId") == null) {
			model.addAttribute("msg", "로그인이 필요합니다!");
			// targetURL 속성명으로 로그인 폼 페이지 서블릿 주소 저장
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		}
		
		return "board/board_write_form";
	}
	
	
	// "BoardWritePro" 서블릿 요청에 대한 글쓰기 비즈니스 로직 처리
	// 주의! 파일 업로드를 위한 multipart/form-data 타입 지정 시
	// 일반적인 request 객체를 통한 파라미터 접근이 불가능하다!
	// => JSP 등을 통해 접근 시 MultipartRequest 객체등을 활용하여 별도의 처리를 수행해야한다!
//	@PostMapping("BoardWritePro")
//	public String writePro(HttpServletRequest request) {
//		System.out.println("board_name : " + request.getParameter("board_name")); // null
//		System.out.println("board_subject : " + request.getParameter("board_subject")); // null
//		System.out.println("board_content : " + request.getParameter("board_content")); // null
//		return "";
//	}
	
	
	// 스프링의 경우 파라미터 매핑을 자동으로 수행하므로 별도로 수행할 추가작업은 없으나
	// 다만, 파일 처리를 위해서는 MultipartFile 등의 타입을 통해 추가 처리는 필요함
	// => 파일 업로드에 사용되는 모든 파라미터를 BoardVO 타입으로 처리
	@PostMapping("BoardWritePro")
	public String writePro(BoardVO board, HttpSession session, Model model, HttpServletRequest request) {
//		System.out.println(board);
		// BoardVO(board_num=0, board_name=admin, board_subject=공지사항, board_content=aaaaaaaaa, board_file1=null, board_file2=null, board_file3=null, board_file=null, file1=MultipartFile[field="file1", filename=test01.htm, contentType=text/html, size=3113], file2=MultipartFile[field="file2", filename=test02.htm, contentType=text/html, size=3717], file3=MultipartFile[field="file3", filename=, contentType=application/octet-stream, size=0], file=MultipartFile[field="file", filename=test01.htm, contentType=text/html, size=3113], board_re_ref=0, board_re_lev=0, board_re_seq=0, board_readcount=0, board_date=null, writer_ip=null)
		// => file1=MultipartFile[] 형식으로 업로드 된 파일이 별도의 객체로 관리됨
		// ---------------------------------------------------------------------------
		if(session.getAttribute("sId") == null) {
			model.addAttribute("msg", "로그인이 필요합니다");
			// targetURL 속성명으로 로그인 폼 페이지 서블릿 주소 저장
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		}
		// ---------------------------------------------------------------------------
		// 작성자 IP 주소 가져오기
		board.setWriter_ip(request.getRemoteAddr());
		System.out.println(board.getWriter_ip()); // 0:0:0:0:0:0:0:1
		// -------------------------------------------------------------------------------------
		// 실제 파일 업로드를 수행하기 위해 프로젝트 상의 가장 업로드 디렉터리(upload) 생성 필요
		// => 외부에서 접근 가능하도록 resources 디렉토리 내에 생성
		// => D:\Spring\workspace_spring5\Spring_MVC_Board\src\main\webapp\resources\ upload
		String uploadDir = "/resources/upload"; // 가상의 경로(이클립스 프로젝트 상에 생성한 경로)
		// 가상 디렉터리에 대한 실제 경로 알아내기
//		String saveDir = request.getServletContext().getRealPath(uploadDir); // 또는
		String saveDir = session.getServletContext().getRealPath(uploadDir); 
		// => session에도 동일한 추출 작업 가능(c.f. getServletContext() : application 객체 가져오는 것)
		System.out.println("실제 업로드 경로 : " + saveDir);
		// => D:\Spring\workspace_spring5\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Spring_MVC_Board\resources\ upload
		
		// 업로드 파일들에 대한 관리의 용이성을 증대시키기 위해
		// 서브(하위) 디렉터리를 활용하여 파일들을 분산 관리 필요
		// => 날짜별로 파일들을 분류하면 관리가 매우 편함
		String subDir = "";
		
 		// 날짜별 서브디렉터리 생성
		// => java.util.Date 클래스보다 java.time 패키지의 LocalXXX 클래스 활용이 더 효율적이다!
		// 1. 현재 시스템의 날짜 정보 객체 생성
		// 1-1) java.util.Date 클래스 활용
//		Date now = new Date(); // 기본 생성자 활용하여 시스템의 현재 날짜 및 시각 정보 생성
//		System.out.println(now); // Tue Dec 19 12:20:58 KST 2023
		
		// 1-2) java.time.LocalXXX 클래스 활용
		// => 날짜 정보만 관리할 경우 LocalDate, 시각 정보 LocalTime, 날짜 및 시각 정보 LocalDateTime 사용
		LocalDate now = LocalDate.now(); // new 키워드 없이 static 메서드 호출
//		System.out.println(now); // 2023-12-19
		// -------------------------
		// 2. 날짜 포맷을 "yyyy/MM/dd" 형식으로 변경 
		// => 해당 날짜를 디렉토리 구조로 바로 활용하기 위해 날짜 구분을 슬래시(/) 기호로 지정 
//		// Date 타입 객체의 날짜 포맷을 변경하려면 java.text.SimpleDateFormat 클래스 활용
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
//		System.out.println(sdf.format(now)); // 2023/12/19
		
		// LocalXXX 타입 객체의 날짜 포맷을 변경하려면 java.time.format.DateTimeFormatter 클래스 활용
//		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy" + File.separator + "MM" + File.separator + "dd");
		// => 경로로 활용 시 File 클래스의 경로구분자를 가져다 사용하지 않고 슬래시(/) 기호 직접 지정도 가능
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd");
//		System.out.println(now.format(dtf)); // 2023/12/19
		
		// 3. 지정한 포맷을 적용하여 날짜 형식 변경한 결과를 변수(subDir)에 저장
		// SimpleDateFormat 과 DateTimeFormatter 사용 시 메서드 호출 주체가 다르다!
//		subDir = sdf.format(now);
		subDir = now.format(dtf);
		
		// 4. 기존 업로드 경로(실제 경로)에 서브디렉토리(날짜 경로) 결합
		saveDir += File.separator + subDir; // File.separator 대신 / 또는 \ 지정도 가능 (saveDir += "\";)
		System.out.println(saveDir);
		// => D:\Spring\workspace_spring5\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Spring_MVC_Board\resources\ upload\2023/12/19


		
		try {
			// 5. 해당 디렉토리 존재하지 않을 경우 자동 생성
			// 5-1) Paths.get() 메서드 호출하여 업로드 경로에 해당하는 Path 객체 리턴받기
			Path path = Paths.get(saveDir); // 파라미터로 업로드 경로 전달
			
			// 5-2) Files.createDirectories() 메서드 호출하여 실제 경로 생성
			// => 이 때, 중간 경로 중 존재하지 않는 경로들을 모두 생성
			Files.createDirectories(path); // 파라미터로 Path 객체 전달
		} catch (IOException e) {
			e.printStackTrace();
		}
		// ----------------------------------
		// BoardVO 객체에 전달(저장)된 실제 파일 정보가 관리되는 MultipartFile 타입 객체 꺼내기
		MultipartFile mFile1 = board.getFile1();
		MultipartFile mFile2 = board.getFile2();
		MultipartFile mFile3 = board.getFile3();
		// MultipartFile 객체의 getOriginalFilename() 메서드 호출 시 업로드 된 파일명 리턴
		System.out.println("원본파일명 1 : " + mFile1.getOriginalFilename()); // 원본파일명 1 : hs_err_pid16752.log
		System.out.println("원본파일명 2 : " + mFile2.getOriginalFilename()); // 원본파일명 2 : hs_err_pid28940.log
		System.out.println("원본파일명 3 : " + mFile3.getOriginalFilename()); // 원본파일명 3 : license.txt

		// ----------------------------------------
		// [ 파일명 중복방지 대책 ]
		// - 파일명 앞에 난수를 결합하여 다른 사용자의 파일과 중복되지 않도록 구분 가능
		// - 일반적인 숫자로 된 난수보다 문자와 숫자를 활용하는 것이 더 효율적
		// - 난수 생성 라이브러리를 활용하거나 UUID 클래스 활용하여 생성
		//   => UUID : 현재 시스템(서버)에서 랜덤 ID 값을 추출하여 제공하는 클래스
		// 	    (UUID : Universally Unique Identifiers 의 약자로 범용 고유 식별자라고 함)
//		String uuid = UUID.randomUUID().toString(); // 리턴타입이 String이 아니므로 toString() 메서드 호출
//		System.out.println("uuid : " + uuid); // uuid : 4fd35384-ccda-4c24-b608-f057d1268ae7
		
		// 생성된 UUID 값을 원본 파일명 앞에 결합(파일명과 구분을 위해 구분자로 "_" 기호 결합)
		// e.g. 4fd35384-ccda-4c24-b608-f057d1268ae7_123.jpg
		// => 단, 파일명 길이 조절을 위해 임의로 UUID 중 앞 8자리 문자열만 추출하여 활용
//		System.out.println("uuid : " + uuid); // uuid : 24fdc547-d00f-4f06-a24e-882067eeadf0
//		System.out.println("uuid : " + uuid.substring(0, 8)); // 24fdc547
//		System.out.println("uuid : " + uuid.substring(0, 8) + "_" + mFile1.getOriginalFilename()); // 24fdc547_license.txt
		// => 서버에 저장할 파일 이름으로 사용할 것임
		
		
		// 생성된 UUID 값(8자리)과 업로드 할 파일명을 결합하여 BoardVO 객체에 저장
		
//		System.out.println(board.getBoard_file1()); // DB에 저장할 용도로 쓰는 멤버변수(MultipartFile X)
		// => file은 String 타입 변수. String 타입의 기본 값은 ""이 아닌 null
		//    첨부파일 선택하지 않을 경우 null 값이 넘어온다
		// => 테이블 생성 시 NN 조건 걸었는데 null 값이 넘어오면 제약조건 위반
		
		// => 단, 업로드 파일이 선택되지 않은 항목은 파일명이 null 값이 전달되므로
		//    BoardVO 객체의 파일명 멤버변수 기본값으로 널스트링("") 처리
		board.setBoard_file1("");
		board.setBoard_file2("");
		board.setBoard_file3("");
		board.setBoard_file("");
		
//		String fileName1 = uuid + "_" + mFile1.getOriginalFilename();
		String fileName1 = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile1.getOriginalFilename(); // 변수 필요없는 경우 쓰지않아도 됨
		String fileName2 = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile2.getOriginalFilename(); // 변수 필요없는 경우 쓰지않아도 됨
		String fileName3 = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile3.getOriginalFilename(); // 변수 필요없는 경우 쓰지않아도 됨
//		System.out.println(fileName1);
//		System.out.println(fileName2);
//		System.out.println(fileName3);
		// => 변수 선언하지않고 UUID.randomUUID().toString()의 형태로 쓸 경우 한 번에 세가지 파일을 업로드할때 난수가 세번 발생하므로
		//    uuid 값이 다 다름(같은 작성글인데 굳이 다를 이유가?)
		// => c.f. uuid 변수를 선언해 같은 값이 나오는데 만약 첨부파일명이 중복이라면 서버에 저장하는 파일명도 중복되므로 문제발생
		// => 첨부파일 3을 첨부하지않았으나 기본값으로 널스트링을 셋해놔서(board.setBoard_file3("")) 파일이 없으나 난수 발생해 문제 
		
		// 파일이 존재할 경우 BoardVO 객체에 서브디렉터리명(subDir)과 함께 파일명 저장
		// ex) 2023/12/19/ef3e51e8_1.jpg
		// 파일명에 같이 서브디렉터리명을 결합해야 나중에 조회하기 쉬움
		if(!mFile1.getOriginalFilename().equals("")) {
			board.setBoard_file1(subDir + "/" + fileName1);
		}
		
		if(!mFile2.getOriginalFilename().equals("")) {
			board.setBoard_file2(subDir + "/" + fileName2);
		}
		
		if(!mFile3.getOriginalFilename().equals("")) {
			board.setBoard_file3(subDir + "/" + fileName3);
		}
		System.out.println("실제 업로드 파일명 1 : " + board.getBoard_file1());
		System.out.println("실제 업로드 파일명 2 : " + board.getBoard_file2());
		System.out.println("실제 업로드 파일명 3 : " + board.getBoard_file3());
		
		// ----------------------------------------------------------------------
		// BoardService - registBoard() 메서드 호출하여 게시물 등록 작업 요청
		// => 파라미터 : BoardVO 객체   리턴타입 : int(insertCount)
		int insertCount = service.registBoard(board); 
//		System.out.println("등록된 게시물 번호 : " + board.getBoard_num());
		// Mapper에서 selectkey 태그를 통해 조회 결과값을 BoardVO 객체에 저장했으므로
		// 해당 객체를 참조하는 현재 클래스에서도 조회된 값에 접근 가능
		// => 참조형변수(객체) 전달했으므로 주소값 넘어가서 같은 주소를 공유하게 되어 
		//    BoardMapper.xml의 쿼리에서 전달한 값이 출력된다(같은 객체 공유하므로 반영됨)
		
		// 게시물 등록 작업 요청 결과 판별
		if(insertCount > 0) { // 성공 시
			try {
				// 업로드 된 파일들은 MultipartFile 객체에 의해 임시 디렉터리에 저장되며
				// 글쓰기 작업 성공 시 임시 디렉터리에서 실제 디렉터리로 이동 작업이 필요
				// => MultipartFile 객체의 transferTo() 메서드를 호출하여 실제 위치로 이동(=> 이 자체가 이미 업로드)
				// => 파일이 선택되지 않은 경우(앞서 파일명을 널스트링으로 세팅해둠) 이동이 불가능(예외 발생)하므로 제외시켜야함
				// => transferTo() 메서드 파라미터로 java.io.File 타입 객체 전달
//				mFile1.transferTo(new File(saveDir, fileName1));
//				mFile2.transferTo(new File(saveDir, fileName2));
//				mFile3.transferTo(new File(saveDir, fileName3)); 
				// => IOException 발생(try/catch 처리)
				
				// => 세번째 첨부파일은 선택을 하지않았으나 객체가 만들어져서 지정 위치에 파일 만들어줌
				//    파일이 존재하는 경우만 실행되도록 각각 조건문 걸어줌
				if(!mFile1.getOriginalFilename().equals("")) {
					mFile1.transferTo(new File(saveDir, fileName1));
				}
				if(!mFile2.getOriginalFilename().equals("")) {
					mFile2.transferTo(new File(saveDir, fileName2));
				}
				if(!mFile3.getOriginalFilename().equals("")) {
					mFile3.transferTo(new File(saveDir, fileName3));
				}
				

			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			// 글목록(BoardList) 서블릿 리다이렉트
			return "redirect:/BoardList";
		} else { // 실패 시
			// "글쓰기 실패!" 메시지 처리(fail_back)
			model.addAttribute("msg", "글쓰기 실패");
			return "fail_back";
			
		}
		
		
		
	}
	
	// "BoardList" 서블릿 요청에 대한 글 목록 조회 비즈니스 로직 처리
	// => 파라미터 : 검색타입(searchType) => 기본값 널스트링("") 설정
	//               검색어(searchKeyword) => 기본값 널스트링("") 설정
	//               페이지번호(pageNum) => 기본값 1 설정
	@GetMapping("BoardList")
	public String list(
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "1") int pageNum,
			Model model) {
//		System.out.println("검색타입 : " + searchType);
//		System.out.println("검색어 : " + searchKeyword);
//		System.out.println("페이지번호 : " + pageNum);
		// ----------------------------------------------------------------
		// 페이징 처리를 위해 조회 목록 갯수 조절 시 사용될 변수 선언
		int listLimit = 10;
		int startRow = (pageNum - 1) * listLimit;
		// --------------------------------------------------------------------
		// BoardService - getBoardList() 메서드 호출하여 게시물 목록 조회 요청
		// => 파라미터 : 검색타입, 검색어, 시작행번호, 게시물 목록갯수
		// => 리턴타입 : List<BoardVO>(boardList)
		List<BoardVO> boardList = service.getBoardList(searchType, searchKeyword, startRow, listLimit);
		// ------------------------------------------------------------------------------
		// 페이징 처리를 위한 계산 작업
		// BoardService - getBoardListCount() 메서드 호출하여 전체 게시물 목록 갯수 조회 요청
		// => 파라미터 : 검색타입, 검색어
		// => 리턴타입 : int(listCount)
		int listCount = service.getBoardListCount(searchType, searchKeyword);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 갯수를 3개로 지정
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 계산된 페이징 처리 관련 값을 PageInfo 객체에 저장
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// ---------------------------------------------------------------------------------------
		// 게시물 목록과 페이징 정보 저장
		model.addAttribute("boardList", boardList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "board/board_list";
	}
	
	// =======================================================================
	// "BoardDetail" 서블릿 요청에 대한 글 상세정보 조회 비즈니스 로직 요청
	@GetMapping("BoardDetail")
	public String boardDetail(@RequestParam int board_num,  Model model) { // pageNum은 돌아가기 등의 작업을 할 때 필요하므로 지금은 안 가져 가도 된다
		// BoardService - getBoard() 메서드 호출하여 글 상세정보 조회 작업 요청
		// => 파라미터 : 글번호(board_num)   리턴타입 : BoardVO(board)
		// 단, 조회수 증가 작업 추가 시 실제 글 상세정보 조회를 제외한
		// 글 수정 또는 답글 작성 과정에서의 조회는 조회수 증가가 수행되지 않도록 파라미터 추가
		// => 파라미터 : 글번호(board_num), 조회수 증가 여부(true : 증가, false : 미증가)
		//    리턴타입 : BoardVO(board)
//		BoardVO board = service.getBoard(board_num);
		BoardVO board = service.getBoard(board_num, true);
		
		// 만약, 조회 게시물 정보가 없을 경우 "존재하지 않는 게시물입니다" 출력 처리
		if(board == null) {
			model.addAttribute("msg", "존재하지 않는 게시물입니다.");
			return "fail_back";
		}
		
		// Model 객체에 BoardVO 객체 저장
		model.addAttribute("board", board); // 객체 리턴받음(조회수 정보 담고있음)
		
		// board/board_view.jsp 페이지 포워딩
		return "board/board_view";
	}
	
	
	// =======================================================================
	// "BoardDelete" 서블릿 요청에 대한 글 삭제 비즈니스 로직 처리
	@GetMapping("BoardDelete")
	public String boardDelete(BoardVO board, @RequestParam(defaultValue = "1") String pageNum, HttpSession session, Model model) { 
		// => board_num 정보를 위해 board 테이블 정보가 모두 다 들어있는 BoardVO 객체로 받아옴(board_num을 @RequestParam해서 파라미터로 받아와도 된다)
		
		// 게시물 삭제 권한 확인
		// 세션 아이디 없을 경우 처리
		String sId = (String)session.getAttribute("sId");
		if(sId == null) {
			model.addAttribute("msg", "로그인이 필요합니다");
			// targetURL 속성명으로 로그인 폼 페이지 서블릿 주소 저장
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		}
		
		// BoardService - getBoard() 메서드 재사용하여 게시물 1개 정보 조회
		// => 조회수가 증가되지 않도록 두번째 파라미터값 false 전달
		BoardVO dbBoard = service.getBoard(board.getBoard_num(), false);
		
		// 조회된 게시물의 작성자(board_name)와 세션 아이디가 다를 경우 "잘못된 접근입니다" 처리
		// => 단, 관리자는 자신의 게시물이 아니더라도 삭제가 가능해야하므로
		//    세션아이디가 관리자가 아닐 경우라는 조건도 추가
		// => 게시글 번호가 null일 경우라는 조건도 추가(이상한 값 집어넣을수도 잇음)
		// => ************ board_num이 아예 넘어오지않았을때의 경우도 추가해주기
		if(dbBoard == null || !sId.equals(dbBoard.getBoard_name()) && !sId.equals("admin")) {
			model.addAttribute("msg", "잘못된 접근입니다");
			return "fail_back";
		}
		
		// BoardService - removeBoard() 메서드 호출하여 글 삭제 작업 요청
		// => 파라미터 : BoardVO 객체(글번호 저장 필수)   리턴타입 : int(deleteCount)
		int deleteCount = service.removeBoard(board); // dbBoard 줘도 됨(글 번호가 저장되어있는 객체이기만 하면 됨)
		
		if(deleteCount > 0) { // DB에서 게시물(레코드) 삭제 성공 시
			try {
				// ------------------------------------------------------------------
				// [ 서버에서 파일 삭제 ]
				// 실제 업로드 경로 알아내기
				String uploadDir = "/resources/upload"; // 가상의 경로(이클립스 프로젝트 상에 생성한 경로)
				String saveDir = session.getServletContext().getRealPath(uploadDir);
				
				// 단, 파일명이 널스트링이 아닐 경우에만 삭제 작업 수행
//				if(!dbBoard.getBoard_file1().equals("")) {
//					// Paths.get() 메서드 호출하여 파일 경로 관리 객체인 Path 객체 생성 후
//					// => 파라미터로 업로드 디렉터리명과 서브디렉터리를 포함한 파일명 결합하여 전달
//					// => Files.deleteIfExists() 메서드 호출하여 파일이 존재할 경우에만 파일 삭제
//					Path path = Paths.get(saveDir + "/" + dbBoard.getBoard_file1());
//					// => 위의 작업은 실제 경로 및 파일 존재 여부와 무관하게 단순 객체만 생성함
//					Files.deleteIfExists(path); // => IOException try/catch 처리(서버에서 파일 삭제 부분 블럭처리)
//				}
//				if(!dbBoard.getBoard_file2().equals("")) {
//					Path path = Paths.get(saveDir + "/" + dbBoard.getBoard_file2());
//					Files.deleteIfExists(path); // => try/catch 처리 이후 if문 부분 복붙해서 file 숫자 바꾸기 
//				}
//				if(!dbBoard.getBoard_file3().equals("")) {
//					Path path = Paths.get(saveDir + "/" + dbBoard.getBoard_file3());
//					Files.deleteIfExists(path); // => try/catch 처리 이후 if문 부분 복붙해서 file 숫자 바꾸기
//				}
				// ------------------------------------------------------------------
				// 파일 삭제에 사용된 중복 코드 제거를 위해 배열 + 반복문 활용
				// 배열 arrFileNames 에 파일명 3개 저장
				String[] arrFileNames = {dbBoard.getBoard_file1(), dbBoard.getBoard_file2(), dbBoard.getBoard_file3()};
//				System.out.println(">>>>>>>>>>>>>>파일명 목록 : " + Arrays.toString(arrFileNames));
				
				// for 문을 활용하여 배열 반복
				for(String fileName : arrFileNames) {
					if(!fileName.equals("")) { // 파일명이 널스트링이 아닐경우에만
						Path path = Paths.get(saveDir + "/" + fileName);
						Files.deleteIfExists(path);
					}
				}
				
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			
			// ------------------------------------------------------------------
			// 글 목록 페이지 리다이렉트(페이지번호 파라미터 전달)
			return "redirect:/BoardList?pageNum=" + pageNum;
		} else { // 삭제 실패
			// "글 삭제 실패!" 메시지 처리
			model.addAttribute("msg", "글 삭제 실패!");
			return "fail_back";
		}
	
		
	}
	
	@GetMapping("BoardModifyForm")
	public String boardModify(BoardVO board, Model model, HttpSession session) {
		// 글 삭제와 권한 판별 동일
		// 세션 아이디 없을 경우 처리
		String sId = (String)session.getAttribute("sId");
		if(sId == null) {
			model.addAttribute("msg", "로그인이 필요합니다");
			model.addAttribute("targetURL", "MemberLoginForm");
			return "forward";
		}
		
		// BoardService - getBoard() 메서드 재사용하여 게시물 1개 정보 조회
		// => 조회수가 증가되지 않도록 두번째 파라미터값 false 전달
		board = service.getBoard(board.getBoard_num(), false);
		
		// 조회된 게시물의 작성자(board_name)와 세션 아이디가 다를 경우 "잘못된 접근입니다" 처리
		// => 단, 관리자는 자신의 게시물이 아니더라도 삭제가 가능해야하므로
		//    세션아이디가 관리자가 아닐 경우라는 조건도 추가
		if(board == null || !sId.equals(board.getBoard_name()) && !sId.equals("admin")) {
			model.addAttribute("msg", "잘못된 접근입니다");
			return "fail_back";
		}	
		
		
		// ****************** 파일 다운로드까지 되도록 처리해놓기(파일명 출력)
		//
		int updateCount = service.modBoard(board);

		// Model 객체에 BoardVO 객체 저장
		model.addAttribute("board", board);
		
		return "board/board_modify_form";
	}
	
}
