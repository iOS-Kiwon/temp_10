//
//  URLDefine.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//
//Webview Load timeout interval 설정값 -------- 데이터통신 timeout interval관리는 Mocha 네트워크 설정파일 참조
#import <Mocha/Mocha.h>

#define DEV_MODE @"DEV_MODE"
#define DEV_MODE_DEFAULT_VALUE @"SM21"
#define DEV_VERSION_CODE @"DEV_NAVI_VERSION"

#define kWebviewTimeoutinterval     20

#define CURRENTAPPVERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define COMPAREVERSIONCHOICE [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define COMPAREVERSIONFORCE [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define COMPAREVERSIONCODE [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//Build And Release History
// 3.8.6 189 2018.08.20 SNS로그인 잔여 개선, 앰플리튜드 , 케넥티드 서비스 플랫폼 , lpayapp 스키마추가
// 3.8.7 190 2018.08.31(업로드) 08/30배포 SNS로그인 네이티브SDK, NHN-DMP
// 3.8.8 191 2018.09.12(업로드) 09/14배포 UA167 Navi5.1 TV쇼핑 페이징,토스트 팝업 UI변경,지문 미등록,미지원 mseq 추가,카테고리 랜덤 추가
// 3.8.9 194 2018.09.21(업로드) 09/27배포 UA167 Navi5.2 베스트매장 카테고리 개편,카드 할인 배너,동영상 플레이어 전채화면 개편,CSP 수정
// 3.9.0 195 2018.10.11(업로드) 10/XX배포 UA168 Navi5.2 생방송영역 이미지 교체 , 29CM 상품셀들 항상초기화,카드할인배너 프리즈버그수정, 메인화면 로딩바 버그수정
// 3.9.1 196 2018.10.17(업로드) 10/18배포 UA168 Navi5.2 페이스 아이디 Description 추가
// 3.9.2 197 2018.11.05(업로드) 11/06배포 UA168 Navi5.2 iPhone XS,XR 해상도 대응
// 3.9.3 199 2018.11.16(업로드) 11/XX배포 UA169 Navi5.2 ARS회원가입, nullSafe 업데이트, 일반로그인시 생채로그인 권유팝업 추가
// 3.9.4 200 2018.11.29(업로드) 12/XX배포 UA170 Navi5.3 홈매장CSP배너, 부킹닷컴 헤더웹뷰 적용, 로그인 툴팁 제거
// 3.9.5 201 2018.12.18(업로드) 12/20배포 UA170 Navi5.3 로그인수단 위치변경, 3D터치 적용(매장)
// 3.9.6 205 2019.01.15(업로드) 01/16배포 UA171 Navi5.4 GS SUPER ,BrightCove ,앱 최소지원버전(iOS9)올림
// 3.9.7 206 2019.01.16(업로드) 01/17배포 UA171 Navi5.4 UIAlertViewController Crash 긴급
// 3.9.8 207 2019.01.24(업로드) 01/XX배포 UA171 Navi5.5 오늘오픈 카테고리UI,인트로 개인화,브라이트코브 영역축소,브라이트코브 starttime
// 3.9.9 208 2019.01.29(업로드) 01/XX배포 UA171 Navi5.5 Webview delegate crash 대응
// 4.0.0 209 2019.02.08(업로드) 01/XX배포 UA173 Navi5.5 WKWebview
// 4.0.1 211 2019.02.22(업로드) 02/XX배포 UA173 Navi5.5 버그수정 배포
// 4.0.2 212 2019.02.28(업로드) 03/XX배포 UA173 Navi5.5 xcode10 적용 , 검색UI개선 , iOS볼륨컨트롤, GS Fresh 폐점처리
// 4.0.3 213 2019.03.07(업로드) 03/XX배포 UA174 Navi5.6 모바일 라이브, GS x Brand 매장 찜기능, 메인매장순서변경
// 4.0.4 214 2019.03.15(업로드) 03/18배포 UA174 Navi5.7 매장 좌우로딩, WebView 60%로딩, WebView웝업퍼, CleverTap
// 4.0.5 215 2019.03.21(업로드) 03/XX배포 UA175 Navi5.7 GS Fresh검색 ,WebView웝업퍼 제거
// 4.0.6 216 2019.04.04(업로드) 04/XX배포 UA176 Navi5.8 홈 매장 듀얼AB
// 4.0.7 217 2019.04.17(업로드) 04/XX배포 UA176 Navi5.8 로그인 풀림 수정 긴급배포
// 4.0.8 218 2019.04.25(업로드) 04/29배포 UA176 Navi5.9 내일TV매장 신설
// 4.0.9 219 2019.05.02(업로드) 05/07배포 UA177 Navi6.0 햄버거 개편
// 4.1.0 220 2019.05.16(업로드) 05/XX배포 UA177 Navi6.1 딜 갯수UI수정,홈Live B 타입UI개선,VOD매장 잔존결함처리
// 4.1.1 221 2019.05.30(업로드) 05/XX배포 UA178 Navi6.2 홈LiveB타입 VOD매장 잔여결함처리,WK script handler 추가,BAN_VOD_GBC(정사각동영상),이미지 검색 추가
// 4.1.2 222 2019.06.13(업로드) 06/14배포 UA179 Navi6.3 이미지 검색 크롭기능추가,GS가 비노출로 변경,인기 검색어
// 4.1.3 223 2019.06.21(업로드) 06/XX배포 UA179 Navi6.4 생방송 메인갱신시 DB 부하 분산
// 4.1.4 224 2019.06.27(업로드) 07/XX배포 UA179 Navi6.4 GS 메인매장
// 4.1.5 225 2019.07.16(업로드) 07/XX배포 UA180 Navi6.5 GS Fresh 개편,햄버거 페이지전환,이미지검색 카메라이미지 변경,로그인 프로세스 정리,toss
// 4.1.6 227 2019.07.25(업로드) 07/XX배포 UA180 Navi6.5 이미지검색 개편
// 4.1.7 228 2019.08.09(업로드) 08/XX배포 UA181 Navi6.6 모바일 라이브 메인,내일TV라운딩(AB),스키마호출
// 4.1.8 229 2019.08.22(업로드) 08/XX배포 UA183 Navi6.6 지금 BestUI 수정
// 4.1.9 230 2019.09.09(업로드) 09/XX배포 UA183 Navi6.7 내일TV 썸네일 640이미지 적용(2차),GS fresh상단 스르륵,플렉서블A타입 롤링, 내일TV 프로모션 구좌 추가, 홈 생방송/데이터/모바일 라운드
// 4.2.0 231 2019.09.17(업로드) 09/XX배포 UA183 Navi6.7 iOS 13 브레이즈 토큰수집 오류로 인한 긴급배포
// 4.2.1 232 2019.09.26(업로드) 09/XX배포 UA184 Navi6.8 메인탭매장 무한루프 , [ab180]수동로그인 ecid쿠키복사 , 내일TV 잔여(3차), 서비스매장 바로가기
// 4.2.2 233 2019.10.01(업로드) 10/XX배포 UA184 Navi6.8 메인탭매장 무한루프버그 긴급배포
// 4.2.3 234 2019.10.24(업로드) 10/XX배포 UA185 Navi6.9 새벽배송,홈&플렉서블 타이틀모듈 추가변경,생방송 스트림 새로 요청
// 4.2.4 236 2019.10.30(업로드) 10/XX배포 UA185 Navi7.0 동적이미지배너, 홈매장 신규타이틀베너 추가, 메인탭 UI개선
// 4.2.5 237 2019.11.01(업로드) 11/04배포 UA185 Navi7.0 풋터 전화번호옆 유료 문구 추가
// 4.2.6 238 2019.11.04(업로드) 11/XX배포 UA186 Navi7.0 긴급배포 편성표 동적배너 링크이동 수정
// 4.2.7 239 2019.11.28(업로드) 11/XX배포 UA187 Navi7.1 UX매장개편 , 주문서 하단 탭바제거
// 4.2.8 241 2019.12.06(업로드) 12/09배포 UA187 Navi7.1 TV상품 혜택 나오도록 수정 , 동영상 상품평 버그 수정, 정보처리 책임자 변경
// 4.2.9 242 2019.12.18(업로드) 12/XX배포 UA188 Navi7.2 UX매장개편 2차 , 동영상 상품평
// 4.3.0 243 2019.12.31(업로드) 01/XX배포 UA188 Navi7.2 홈매장 카테고리 REUSE 버그수정 긴급배포
// 4.3.1 244 2020.01.16(업로드) 01/XX배포 UA188 Navi7.4 홈GNB개선,UX매장 개편3차
// 4.3.2 245 2020.01.30(업로드) 01/XX배포 UA188 Navi7.4 GS fresh 장바구니, PRD_C_B1 홈매장에서 높이
// 4.3.3 246 2020.02.12(업로드) 02/XX배포 UA188 Navi7.4 Swizzle side hotfix, push 수신 시 로그인 동기화 처리, 패드 회전 진입 시 버그 수정
// 4.3.4 247 2020.02.17(업로드) 02/XX배포 UA188 Navi7.5 내일TV핑퐁배너 -> 홈 메인에서도 노출되도록수정
// 4.3.5 248 2020.02.27(업로드) 02/XX배포 UA189 Navi7.6 상품평 동영상첨부 기본SDK로 변경,Tune SDK제거,검색창 UI수정, 타이틀베너 이름 노출
// 4.3.6 250 2020.03.13(업로드) 03/16배포 UA189 Navi7.6 카카오싱크 키변경,footer 대표이사 이름 변경, 홈 매장 인기 검색어 순위 컴포넌트 개선,전 매장 타이틀 배너 폰트 조정 ,Push 인증서 갱신 : PMS, Braze (iOS),Apple 정책 대응 : 단말 해상도 맞춤 처리,매장탭 빠르게스크롤시 불일치 하는 버그 수정
// 4.3.7 251 2020.03.26(업로드) 03/XX배포 UA189 Navi7.6 구MC URL 변경 , 라이브톡 SNS공유하기 할때 설치 체크를 앱에서 하고 얼럿 노출 , 엠플리튜드연령대 처리 예외 로직 추가 ,구매하기 버튼 가변처리,  푸터 개인정보 취급방침, 청소년 보호정책 노탭 처리
// 4.3.7 251 2020.03.26(업로드) 03/XX배포 UA189 Navi7.6 구MC URL 변경 , 라이브톡 SNS공유하기 할때 설치 체크를 앱에서 하고 얼럿 노출 , 엠플리튜드연령대 처리 예외 로직 추가 ,구매하기 버튼 가변처리,  푸터 개인정보 취급방침, 청소년 보호정책 노탭 처리
// 4.3.8 254 2020.04.09(업로드) 04/XX배포 UA190 Navi7.7 편성표 공영방송 앵커처리,GS Fresh 검색
// 4.3.9 255 2020.04.XX(업로드) 04/XX배포 UA191 Navi7.8 GS Fresh 더보기 제거, 검색어 UI개선, 라이브톡 진입버튼변경, 단품네이티브 ,모바일라이브 수정
// 4.4.1 257 2020.05.18(업로드) 05/XX배포 UA191 Navi7.8 단품 네이티브 핫픽스
// 4.4.2 258 2020.05.22(업로드) 05/XX배포 UA191 Navi7.8 매장 탭이동 배너클릭시 이동이 정확하지 않는이슈 긴급배포
// 4.4.3 259 2020.05.28(업로드) 05/XX배포 UA191 Navi7.9 주문서 선물하기 연락처 연동,Voice over 읽는 순서 변경,애플 아이디 로그인 적용,메인 검색창내 연관 검색어 노출,상품 네이티브 스켈레톤 로딩 애니 적용,홈 하단 60개 구좌 상품컴포넌트 노출 UI AB TEST,모바일라이브 UI 수정,운영 배포 이후 긴급 수정건 리스트 (부작업 포함)
// 4.4.4 260 2020.06.01(업로드) 06/XX배포 UA191 Navi7.9 연관검색어, 스켈레톤 긴급수정배포
// 4.4.5 262 2020.06.03(업로드) 06/XX배포 UA191 Navi7.9 SM14로 잘못 배포된것 긴급수정배포
// 4.4.6 264 2020.06.11(업로드) 06/XX배포 UA193 Navi7.9 SM14->SM20,라이브톡UI개선,선물하기,로그인UI변경
// 4.4.7 265 2020.06.18(업로드) 06/XX배포 UA193 Navi8.0 혜택 매장 UI 개선, 햄버거버튼 내 JBP영역 자동화 및 테마관 노출 영역 분리, 단품 - 배송지 버튼 및 관련 영역 UI 개선 , 로그인 화면 UI 개선, Webview http 응답에 따른 상태 예외 처리,단품 배송지 UI 개선
// 4.4.8 266 2020.06.25(업로드) 06/XX배포 UA193 Navi8.1 GS X 브랜드샵 탭매장 추천 PG 신설, Braze inAppMessagePopup 비 노출처리
// 4.4.9 268 2020.07.09(업로드) 07/XX배포 UA194 Navi8.1 홈메인 생방송 배너swift로 전환,iOS14 선 대응 - 다국어 지원 제거 , MC 설정 페이지 디자인 개선 ,[android/ios]하단 탭바 아이콘 SVG 적용 반영 , MC 홈 자주 찾는 카테고리 No Image 개선 ,모바일 라이브 내 무형상품(렌탈/여행/시공) 판매
// 4.5.0 269 2020.07.16(업로드) 07/XX배포 UA194 Navi8.1 홈메인 생방송 배너 타임 오류크래쉬로 긴급배포
// 4.5.1 270 2020.07.23(업로드) 07/XX배포 UA194 Navi8.2 라이브톡 화면 문구 및 UI 개선 요청 , UIWebView 관련 모듈 제거 , 홈 하단 개인화구좌 신규UI 추가 ,브랜드 개인화매장 UX개선
// 4.5.1 274 2020.08.07(업로드) 08/XX배포 UA195 Navi8.3 애플 로그인 살리기 ,햄버거버튼 내 메뉴바 제공, 새벽매장 구매하기UI(장바구니) 추가, 새벽매장(탭매장) 카테고리 UX 개선
// 4.5.2 275 2020.08.12(업로드) 08/XX배포 UA196 Navi8.3 라이브톡 하단탭바 채팅창 가림현상 긴급배포
// 4.5.3 276 2020.08.20(업로드) 08/XX배포 UA197 Navi8.3 iOS 웹 스크립트 문의 , 하단탭 버그 수정 , 매장 스크롤중 간헐적으로 발생하는 크래쉬 , iOS 14 베타에서 1:1 모바일 상담 이미지 첨부시 크래쉬 나는부분 임시처리 로직추가
// 4.5.4 277 2020.08.27(업로드) 09/XX배포 UA197 Navi8.3 프로모션 팝업 안뜨는 부분 긴급수정배포
// 4.5.5 279 2020.09.03(업로드) 09/XX배포 UA197 Navi8.4 구매하기 UI/UX 개선(1차),후레쉬 장바구니 버튼 "취소되었습니다" 기능 제거,XCode 12 / iOS14 대응 개발,SNS공유하기 기능에서 '핀터레스트' 제거,TV 시그니처상품 브랜딩매장,APP 푸시설정 프로모션 팝업
// 4.5.6 281 2020.09.11(업로드) 09/14배포 UA198 Navi8.5 구매하기 UI/UX 개선, 1단 아이콘형 카테고리(내일도착)
// 4.5.7 282 2020.09.17(업로드) 09/XX배포 UA198 Navi8.5 APP 푸시설정 프로모션 팝업, IOS 성능개선을 위한 Swift 적용영역 확대 , 매장 이미지URL 링크 URL 부분에 trim 추가 , 슈퍼 매장에서 이미지 배너 리로드시 배열 유요성 한번더 체크
// 4.5.8 283 2020.09.24(업로드) 09/XX배포 UA199 Navi8.5 Moloco 사용을위한 adid 처리로직 추가,성인단품 진입시 헤더 겹침현상 수정, 이런상품 어떠세요 mseq로직 보완
// 4.5.9 284 2020.10.08(업로드) 10/XX배포 UA199 Navi8.5 시그니쳐 매장 오픈 후 추가개발 요청사항, TV신규 매장 PENDING ,메인탭 매장명 UI 개선
 

//UserAgent Number 중요 v3.2.7 = 135
// 3.2.12 = 138 //2016/01/18 - 3.2.10 부터
// 3.3.1 = 139 //바로구매 적용할 예정 2016.04.12 배포 예정
// 3.3.2 = 140 //back key, push 팝업
// 3.3.4 = 141 //동영상 스트림 업로드 부터
// 3.3.5 = 142 //날방
// 3.3.6 = 143 //공유하기
// 3.3.7 = 144 //라이브톡 이미지 첨부
// 3.3.8 = 145 //Line 공유 추가
// 3.3.9 = 146 //숏방, SNS공유(네이티브 UI)
// 3.4.0 = 147 //숏방 매장 없이 배너 링크형
// 3.4.2 = 148 //타임딜
// 3.4.4 = 149 //탭바 개편(최근 본 상품 썸네일)
// 3.4.6 = 150 //1:1 모바일 상담 UI 개편
// 3.4.7 = 151 //인기프로그램 배너 6개로 확장
// 3.4.8 = 152 //사이드매뉴(햄버거) 개편
// 3.5.0 = 153 //안드로이드 버전에 맞춤
// 3.5.2 = 154 // B_IG4XN 수정
// 3.5.3 = 155 //상품평 팝업/ 햄버거 타이틀 수정
// 3.5.4 = 156 //주문완료 처리
// 3.5.6 = 157 //편성표매장 탭이동 처리 , 편성표 웹뷰에서 tabId를 담아 리다이렉트
// 3.5.9 = 158 //안드로이드와 통일 (방송알림 인코딩 여부 체크),숏방 이벤트 버전 체크
// 3.6.0 = 159 //Amplitude
// 3.6.3 = 160 //오늘추천 혜택, 동적 이미지 배너
// 3.7.3 = 161 //상품평 웹뷰
// 3.7.5 = 162 //회원가입후 자동로그인 처리
// 3.8.3 = 163 //편성표 개편
// 3.8.4 = 164 //로그인 롤백용 기준
// 3.8.5 = 165 //Android 로그인관련해서 올리는것 따라올림(SNS 자동인증)
// 3.8.6 = 166 //Android 로그인관련해서 올리는것 따라올림(SNS 자동인증 긴급배포)
// 3.8.7 = 167 //SNS 회원가입 (앱 SDK 연동 및 기타 규격 정의 20180820)
// 3.9.0 = 168 //안드로이드와 동기화
// 3.9.0 = 168 //안드로이드와 동기화
// 3.9.3 = 169 //ARS로그인 추가
// 3.9.4 = 170 //부킹닷컴 헤더추가된 웹뷰 추가, CSP 배너 추가
// 3.9.6 = 171 //GS슈퍼 웹에서 신앱관련 처리해야함.
// 3.9.8 = 172 //Android 동영상 가로세로
// 4.0.0 = 173 //WK웹뷰 적용
// 4.0.3 = 174 //모바일 라이브
// 4.0.5 = 175 //풀웹뷰 적용 toapp://notabfullweb?
// 4.0.6 = 176 // 위 풀웹뷰(회원동선) 실제 적용
// 4.0.8 = 177 // VOD 매장 적용
// 4.1.1 = 178 // iOS : user script 이용로직 적용
// 4.1.2 = 179 // 이미지 검색 크롭기능추가
// 4.1.5 = 180 // toss 팝업
// 4.1.6 = 180 // 이미지검색 동선 개편 (181로 하려다 다시 180으로 내렸음)
// 4.1.7 = 181 // 웹뷰내 네트워크 체크
// 4.1.8 = 183 // toapp://newpage
// 4.2.1 = 184 // 안드 따라 올라감
// 4.2.3 = 185 // 안드 따라 올라감 (방어로직 구분)
// 4.2.6 = 186 // 편성표 매장 동적배너 긴급패치를 위한 버전올림 (구버전에서 안나오도록 서버수정)
// 4.2.7 = 187 // UX매장개편 에멀전시 구분자
// 4.2.9 = 188 // 아이폰 상품평 동영상 인코딩 변경에 따른 구분 처리
// 4.3.5 = 189 // 카카오 싱크용 토큰 적용
// 4.3.7 = 190 // 공유하기 스키마 변경점
// 4.4.0 = 191 // 단품 네이티브
// 4.4.6 = 193 // 선물하기
// 4.4.9 = 194 // 모바일 라이브 구앱 대응
// 4.5.1 = 195 // 애플로그인 심사거절 대응
// 4.5.2 = 196 // 애플로그인 심사거절 대응
// 4.5.3 = 197 // 애플로그인 심사거절 대응
// 4.5.6 = 198 // 구매하기 UI변경
// 4.5.8 = 199 // adid ( 적용버전 ) 기준으로 ab및 광고/추천이 이루어질꺼라서요

#define USERAGENTCUSTOMVERSION @"199"
#define USERAGENTCODE @"BS"
#define USERAGENTAPPGB @"AG001"

//그룹매장 구조 api version=1.1 v2.2.3.6 부터 version=1.2
//이전버전 1.1 이후---- 20141216 1.3
//--- 20150324  3.1.2.13이후 1.4 맞춤딜
//--- 20150407 v3.1.3.14부터 1.5
//--- 20150602 v3.1.5.16부터 1.8
//--- 20150814 v3.1.7.18부터 1.9
//--- 20150818 v3.2.0.19부터 2.0
//--- 20150922 v3.2.2.21부터 2.1
//--- 201510xx v3.2.4.23 == 2.2 - 동영상 셀
//--- 201510xx v3.2.5.24 =  2.3 - 상품셀 UI변경 & 뱃지
//--- 201510xx v3.2.6.25부터 2.4 - 베딜/티비쇼핑 생방송영역
//--- 201511xx v3.2.7   부터 2.5 - 티비쇼핑 개편
//--- 201601xx v3.2.8   부터 2.6 - 날방 & 마트 개편
//--- 201602xx v3.2.10  부터 2.7 - 라이브톡 배너 및 플레이어 추가
//--- 201605xx v3.3.3  부터 2.8 - 지금 베스트 추가
//----201606xx v3.3.4 부터 2.9 - 기획전, 백화점, 네비게이션 아이콘 추가
//----201606xx v3.3.5 부터 3.0 - 날방 매장으로 추가
//----201607xx v3.3.7 부터 3.1 - 안드로이드와 싱크 맞춤
//----201612xx v3.4.6 부터 3.2 - 지금 베스트 매장 개편
//----20170119 v3.4.7 부터 3.2 - 생방송영역 노출조건변경,어반에어쉽 SDK 제거 PMS테스트 필수,최근본상품 이미지주소 변경,하단풋터 패밀리사이트,인기프로그램 6개,시티은행앱카드추가,통신타임아웃10초
//----20170216 v3.4.8 부터 3.3 - 사이드매뉴(햄버거) 개편
//----20170302 v3.4.9 부터 3.4 - 매장 탭 이동
//----20170406 v3.5.1 부터 3.5 - 오늘추천 카테고리 전체보기 external://leftnavi
//----20170615 v3.5.4 부터 3.6 - 플렉서블E
//----20170713 v3.5.6 부터 3.7 - 편성표 매장
//----20170824 v3.5.9 부터 3.8 - AI 매장
//----20170924 v3.6.1 부터 3.9 - 오늘오픈
//----20171102 v3.6.3 부터 4.0 - 오늘추천 혜택, 동적 이미지 배너
//----20180208 v3.7.1 부터 4.1 - 29CM , TV쇼핑 혜택 , TV쇼핑 하단여백없는 가변배너
//----20180306 v3.7.3 부터 4.2 - TV미리주문(구TV쇼핑) 듀얼플레이어
//----20180405 v3.7.6 부터 4.3 - 개인화 매장 팝업
//----20180418 v3.7.7 부터 4.4 - AD 매장
//----20180426 v3.7.8 부터 4.5 - 인기프로그램 / TV쇼핑 혜택 아이콘
//----20180503 v3.7.9 부터 4.6 - 적립금 / 테마 키워드쇼핑
//----20180524 v3.8.0 부터 4.7 - GS X 브랜드매장 카테고리 추가
//----20180705 v3.8.3 부터 4.8 - TV편성표 개편
//----20180705 v3.8.4 부터 4.9 - 이벤트매장 개편 / 로그인화면 개편
//----20180802 v3.8.5 부터 5.0 - 29cm 페이징 추가, 홈매장 동적 셀 API 적용
//----20180912 v3.8.8 부터 5.1 - TV쇼핑탭 페이징
//----20180920 v3.8.9 부터 5.2 - 지금베스트 개선, 카드할인 베너 추가
//----20181129 v3.9.4 부터 5.3 - CSP 동적 배너 추가 / 부킹닷컴 헤더추가된 웹뷰 추가
//----20190115 v3.9.6(7) 부터 5.4 - GS SUPER
//----20190124 v3.9.8 부터 5.5 오늘오픈 카테고리 수정
//----20190307 v4.0.3 부터 5.6 매장탭 , 브랜드 찜
//----20190321 v4.0.5 부터 5.7 GS fresh 메인 상품 4개에서 10개로 변경
//----20190404 v4.0.6 부터 5.8 홈 매장AB테스트
//----20190425 v4.0.8 부터 5.9 내일TV매장
//----20190502 v4.0.9 부터 6.0 햄버거 개편
//----20190516 v4.1.0 부터 6.1 홈메인 B타입 이미지사이즈 변경
//----20190530 v4.1.1 부터 6.2 내일TV GBC타입 추가, 이미지 검색 URL
//----20190613 v4.1.2 부터 6.3 GS가 비노출
//----20190627 v4.1.3 부터 6.4 GS Choice 매장
//----20190716 v4.1.5 부터 6.5 GS Fresh 개편
//----20190809 v4.1.7 부터 6.6 홈메인 모바일 라이브
//----20190909 v4.1.9 부터 6.7 내일TV 혜택벳지
//----20190926 v4.2.1 부터 6.8 
//----20191024 v4.2.3 부터 6.9 내일도착(새벽배송)
//----20191030 v4.2.4 부터 7.0 iOS편성표 동적이미지배너, 홈매장 신규타이틀베너 추가
//----20191128 v4.2.7 부터 7.1 UX매장 개편
//----20191218 v4.2.9 부터 7.2 UX매장 개편 2
//----20200116 v4.3.1 부터 7.4 UX매장 개편 3 (iOS)7.3건너뜀
//——--20200217 v4.3.4 부터 7.5 내일TV핑퐁배너 -> 홈 메인에서도 노출되도록수정 (포맷에 맞춘것)
//----20200227 v4.3.5 부터 7.6 타이틀 베너 이름노출 조건 추가
//----20200326 v4.3.7 부터 7.7 API_SRL -> PRD_C_SQ 로 동작하도록 변경함.
//----20200430 v4.4.0 부터 7.8 단품 네이티브
//----20200528 v4.4.3 부터 7.9 홈화면 A/B
//----20200618 v4.4.7 부터 8.0 GS 혜택 관련
//----20200625 v4.4.8 부터 8.1 GS X 브랜드 추천관
//----20200723 v4.5.1 부터 8.2 홈 하단 개인화구좌 신규UI 추가
//----20200806 v4.5.1 부터 8.3 새벽배송 매장 장바구니 추가, 엥커+텝 로직 변경 (20200723 배포 하지 못하여 버전 유지)
//----20200903 v4.5.5 부터 8.4 TV 시그니처 매장
//----20200910 v4.5.6 부터 8.5 내일도착 탭 UI 변경

/*
 배너 100 + 카피1 100 : 2016/12/01 00:00:00 ~ 2016/12/31 23:59:59
 배너 210 + 카피1 210 : 2017/01/01 00:00:00 ~ 2017/01/05 23:59:59
 배너 210 + 카피1 100 : 2017/01/06 00:00:00 ~ 2017/01/10 23:59:59
 배너 100 + 카피1 210 : 2017/01/11 00:00:00 ~ 2017/01/15 23:59:59
 배너 100 + 카피1 null : 2017/01/16 00:00:00 ~ 2017/01/20 23:59:59
 배너 100 + 카피1 string : 2017/01/21 00:00:00 ~ [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] length] > 0 ? [[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] : @"7.2"2017/01/25 23:59:59
 */

#define APP_NAVI_VERSION @"8.5"

#define PRODUCT_NATIVE_VERSION @"1.0"

#if SM14 && !APPSTORE
#define GROUPUILISTURL [NSString stringWithFormat:@"app/navigation?version=%@&os=IOS&appver=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] length] > 0 ? [[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] : APP_NAVI_VERSION,COMPAREVERSIONCODE]
#else
#define GROUPUILISTURL [NSString stringWithFormat:@"app/navigation?version=%@&os=IOS&appver=%@",APP_NAVI_VERSION,COMPAREVERSIONCODE]
#endif


//DEVICEUUID
#define DEVICEUUID  [NSString stringWithFormat:@"%@", [Common_Util getKeychainUUID]]
#define APPLE_AD_ID [NSString stringWithFormat:@"%@", [Common_Util getAppleADID]]


//푸시 수신여부 값 저장
#define GS_PUSH_RECEIVE @"GS_PUSH_RECEIVE"


//##################### API URL DEFINE #################################
#if SM14 && !APPSTORE
#define SERVERMAINDOMAIN [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"TM14"] ? @"tm14.gsshop.com" : [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"M"] ? @"m.gsshop.com" : @"sm21.gsshop.com"
#define SERVERURI [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"TM14"] ? @"http://tm14.gsshop.com" : [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"M"] ? @"http://m.gsshop.com" : @"http://sm21.gsshop.com"
#define SERVERURI_HTTPS [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"TM14"] ? @"http://tm14.gsshop.com" : [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"M"] ? @"https://m.gsshop.com" : @"https://sm21.gsshop.com"
// SSL 설정용
#define SERVERMAINDOMAINFORSSL [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"TM14"] ? @"tm14.gsshop.com" : [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"M"] ? @"https://m.gsshop.com" : @"sm21.gsshop.com"
#else
#define SERVERMAINDOMAIN @"m.gsshop.com"
#define SERVERURI @"http://m.gsshop.com"
#define SERVERURI_HTTPS @"https://m.gsshop.com"
// SSL 설정용
#define SERVERMAINDOMAINFORSSL @"m.gsshop.com"
#endif



#define IDCSERVERDOWNURL    @"http://apperror.gsshop.com/oops.html"             // IDC 점검중 체크 페이지
#define IDCLANDINGPAGE      @"http://apperror.gsshop.com/mc_parking.html"       // IDC 점검중 페이지


// nami0342 - App crash log 수집 서버
#define SERVER_CRASH_LOG    @"http://oops.gsshop.com:10001/app/log/register"

#if SM14 && !APPSTORE
#define SERVERIMAGEDOMAIN [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_MODE] isEqualToString:@"TM14"] ? @"devimage.gsshop.com" : @"image.gsshop.com" //M,SM 모두 
#else
#define SERVERIMAGEDOMAIN @"image.gsshop.com"
#endif


//앱 구동시 화면에 표시될 alert view 태그
//1010 = 옵트인알럿
#define TAGVIEWLAUNCHOPTIN 1010
//777 = 강제업데이트 알럿
#define TAGVIEWLAUNCHFORCEUPDATE 777
//444 = 나중에 업데이트 알럿
#define TAGVIEWLAUNCHLATERUPDATE 444



//API 섹션 타입 정의

//홈매장 딜타입정의 - 베스트딜 추후 BTCLIST 베스트딜 로 변경
#define HOMESECTTCLIST @"TCLIST"

//홈매장 딜타입정의 - TV쇼핑 (데이터홈쇼핑)
#define HOMESECTTDCLIST @"TDCLIST"

//홈매장 딜타입정의 - 필터 컨텐츠 리스트 - 오늘오픈
#define HOMESECTFCLIST @"FCLIST"

//홈매장 딜타입정의 - 이벤트 이미지
#define HOMESECTEILIST @"EILIST"
//홈매장 - GS혜택 이벤트 UI개편
#define HOMESECTEFXCLIST @"EFXCLIST"

//홈매장 딜타입정의 - 브랜드관
#define HOMESECTBCLIST @"BCLIST"

//yunsang.jin 홈 플랙서블 매장
#define HOMESECTFXCLIST @"FXCLIST"

//yunsang.jin 홈 백화점 매장
#define HOMESECTDFCLIST @"DFCLIST"

//홈매장 날방
#define HOMESECTNTCLIST @"NTFCLIST"

//홈매장 편성표매장
#define HOMESECTSLIST @"SLIST"

//29CM 매장
#define HOMESECTFEEDLIST @"FEEDLIST"

//GS SUPER 매장
#define HOMESECTSUPLIST @"SUPLIST"

//VOD 매장
#define HOMESECTVODLIST @"VODLIST"

//VOD 매장
#define HOMESECTNFXCLIST @"NFXCLIST"


//카테고리 선택 Userdefaults Key
#define SPECIALSECTIONLEFTSTYPE @"SUB_PRODUCTLIST_SUGGEST"



//ABtest
#define ABTESTBULLETVERSTR(strver) [NSString stringWithFormat:@"&type=%@", strver]
#define ABTESTSEARCHVALUE [NSString stringWithFormat:@"section/search/abTestValue"]


//이벤트 Promotion popup Get
#define PROMOTIONAPIURL [NSString stringWithFormat:@"%@/shop/mobilePromotionInfo",SERVERURI]
//인증-토큰로그인
#define GSUSERTOKENLOGINURL [NSString stringWithFormat:@"customer/token-login"]
//인증-토큰로그아웃
#define GSUSERTOKENLOGOUTURL [NSString stringWithFormat:@"customer/token-log-out"]
//인증-토큰 로그인 후 생성된 토큰을 사용한 토큰인증
#define GSUSERTOKENAUTHURL [NSString stringWithFormat:@"customer/token-certification"]
//SNS 연동 조회
#define GSUSERSNSCHECK [NSString stringWithFormat:@"customer/cust-sns-link"]
//SNS 연동 해제
#define GSUSERSNSCLOSE [NSString stringWithFormat:@"customer/cust-sns-link-close"]
//SNS 연동 연결등록
#define GSUSERSNSOPEN [NSString stringWithFormat:@"customer/cust-sns-link-open"]
//30일간 비밀번호 변경 팝업 안보기 서버 처리
#define GSPASSWORDCHANGE30(catvId) [NSString stringWithFormat:@"%@/app/customer/saveNtcCnfDPwd?catvId=%@",SERVERURI,catvId]
//30일간 로그인번호 변경 팝업 안보기 서버 처리
#define GSTVLOGINNUMBERCHANGE30 [NSString stringWithFormat:@"%@/member/updateNtcCnfDTvPwd.gs",SERVERURI]

//로그인 상태를 자동로그인 상태로 전환
#define GSAUTOAUTHCHANGE [NSString stringWithFormat:@"customer/token-login-reg"]

#define PHOTOUPLOADBYTELIMIT 10240000 //사진첨부 제한 크기 byte 10 MB
#define VIDEOUPLOADBYTELIMIT 209715200 //동영상첨부 제한 크기 200Mbyte
#define LIVETALKPHOTOLIMIT 204800 //라이브톡 이미지 업로드 제한 크기 200K
#define PHOTOUPLOADWIDTHLIMIT 600.0 //사진첨부시 이미지의 가로 넓이 제한 600


#define WISELOGPAGEURL(pagestr) [NSString stringWithFormat:@"%@/app/statistic/wiseLog%@", SERVERURI, pagestr]
#define WISELOGCOMMONURL(pagestr) [NSString stringWithFormat:@"%@/mobile/commonClickTrac.jsp%@", SERVERURI, pagestr]
#define WISELOGSHORTBANG(pagestr) [NSString stringWithFormat:@"%@/app/static/shortbang%@", SERVERURI, pagestr]


//찜 등록 api
extern NSString *FAVORITE_CRE_URL;
//#define FAVORITEREGURL(prd) [NSString stringWithFormat:@"mygsshop/myWishCreItems.gs?prdCd=%@", prd]
#define FAVORITEREGURL(prd) [[NSString stringWithFormat:@"%@%@", FAVORITE_CRE_URL, prd] stringByReplacingOccurrencesOfString:SERVERURI withString:@""]

extern NSString *TV_LIVE_URL;
#define TV_LIVE_URLWITHCODE(seccode) [NSString stringWithFormat:@"%@?sectionCode=%@&version=%@", TV_LIVE_URL, seccode ,APP_NAVI_VERSION]

extern NSString *TVSHOP_LIVE_URL;
#define TVSHOP_LIVE_URLWITHCODE(seccode) [NSString stringWithFormat:@"%@?sectionCode=%@&version=%@", TVSHOP_LIVE_URL, seccode,APP_NAVI_VERSION]

extern NSString *TVSHOP_DATA_URL;
#define TVSHOP_DATA_URLWITHCODE(seccode) [NSString stringWithFormat:@"%@?sectionCode=%@&version=%@", TVSHOP_DATA_URL, seccode,APP_NAVI_VERSION]

extern NSString *HOME_MAIN_TVSHOP_LIVE_URL;
#define HOME_MAIN_TVSHOP_LIVE_URLWITHCODE(seccode) [NSString stringWithFormat:@"%@?sectionCode=%@&version=%@", HOME_MAIN_TVSHOP_LIVE_URL, seccode,APP_NAVI_VERSION]

extern NSString *HOME_MAIN_TVSHOP_DATA_URL;
#define HOME_MAIN_TVSHOP_DATA_URLWITHCODE(seccode) [NSString stringWithFormat:@"%@?sectionCode=%@&version=%@", HOME_MAIN_TVSHOP_DATA_URL, seccode,APP_NAVI_VERSION]

extern NSString *HOME_MAIN_MOBILE_LIVE_URL;
#define HOME_MAIN_MOBILE_LIVE_URLWITHCODE(seccode) [NSString stringWithFormat:@"%@?sectionCode=%@&version=%@", HOME_MAIN_MOBILE_LIVE_URL, seccode,APP_NAVI_VERSION]


extern NSString *TVSHOP_SALEINFO_URL;
#define TVSHOP_SALEINFO_URLWITHCODE(seccode) [NSString stringWithFormat:@"%@?sectionCode=%@&version=%@", TVSHOP_SALEINFO_URL, seccode,APP_NAVI_VERSION]

extern NSString *BESTRCMDYN;

extern NSString *BESTRCMDURL;

#define BESTRCMDURL_URLWITHDEALNO(dealNum) [NSString stringWithFormat:@"%@?dealNo=%@", BESTRCMDURL, dealNum]

extern NSString *NALBANG_LIVE_URL;

extern NSDate *START_TIME_FORCHECK;

extern NSDictionary *LEFTNAVIGATION_DIC;

//헤더상단 네이티브
extern NSString *PRD_NATIVE_YN;

#define SHOPSTART_URL [NSString stringWithFormat:@"%@/shop/shopstart.gs", SERVERURI]

//#define WKSESSION_URL WISELOGPAGEURL(@"?mseq=000000")
//#define WKSESSION_URL [NSString stringWithFormat:@"%@/mobile/commonClickTrac.jsp", SERVERURI]
#define WKSESSION_URL [NSString stringWithFormat:@"http://image.gsshop.com/mc/cookieSync.html"]

//최종앱버전정보 20151123 변경
#define GSAPPVERSION [NSString stringWithFormat:@"shop/shopIosVer?appver=%@",COMPAREVERSIONCODE]
#define GSMAINTAINSERVERFLAGURL [NSString stringWithFormat:@"%@/oops.html",SERVERURI]


//찜 페이지 URL
#define FAVORITE_PAGE_URL [NSString stringWithFormat:@"%@/mygsshop/myWishListMain.gs", SERVERURI]

//뱃지정보가져오기
#define GSGETBADGEURL [NSString stringWithFormat:@"apis/v2.6/tabbar/badge/list"]

//인기검색어
#define GSGETHOTKEYWORDURL [NSString stringWithFormat:@"apis/v2.6/search/hotKeyword?rownum=20"]

//자동완성 데이터 가져오기 2.7개편
#define GSSEARCHAUTOCOMPLETEURL(word) [NSString stringWithFormat:@"/section/apis/v2.8/search/autoComplete?query=%@",word]

//단어검색 웹페이지로이동
#define GSSEARCHURL(mseqnum,word,abTest) [NSString stringWithFormat:@"%@/search/searchSect.gs?fromApp=Y&mseq=%@&tq=%@&ab=%@",SERVERURI, mseqnum, word,abTest]

//TV편성표 매장 검색
#define GSSEARCHMSEQ1 [NSString stringWithFormat:@"401170"]     //- 최근검색어 : 401170
#define GSSEARCHMSEQ2 [NSString stringWithFormat:@"402848"]     //- 인기검색어 : 402848
#define GSSEARCHMSEQ3 [NSString stringWithFormat:@"401172"]     //- 다이렉트검색(돋보기) : 401172 //403589
#define GSSEARCHMSEQ4 [NSString stringWithFormat:@"401171"]     //- 연관검색어(자동완성) : 401171
#define GSSEARCHMSEQ5 [NSString stringWithFormat:@"419271"]     //- 추천연관검색어 : 419271
#define GSSEARCHMSEQ6 [NSString stringWithFormat:@"419371"]     //- 추천연관검색어 from Home : 419371


//브랜드 리스트
#define GSBRANDLISTURL [NSString stringWithFormat:@"apis/v2.6/brand/list"]


//프로모션 키워드 리스트
#define GSPROMOKEYWORDLISTURL [NSString stringWithFormat:@"apis/v2.6/search/promotionKeyword"]


// EC통합재구축 상품평 정보가져오기
//20160114 상품평 cust_no 추가
#define GSRECVGOODSINFOURL(prdid,custno) [NSString stringWithFormat:@"%@/knownew/estimate/estimateWrite.gs?%@%@", SERVERURI, prdid,custno] //받기
#define GSRECVGOODSINFOURL_MOD(prdid,custno) [NSString stringWithFormat:@"%@/knownew/estimate/estimateModify.gs?%@%@", SERVERURI, prdid,custno] //받기


//상품평 저장
// EC통합재구축 상품평 저장
//20160114 상품평 cust_no 추가
#define GSSENDGOODSINFOURL [NSString stringWithFormat:@"%@/knownew/estimate/estimateWriteProc.gs?format=json",SERVERURI] //보내기
#define GSSENDGOODSINFOURL_MOD [NSString stringWithFormat:@"%@/knownew/estimate/estimateModifyProc.gs?format=json",SERVERURI] //보내기


//푸시정보보내기
#define PUSHCUSTINFOURL_NEW [NSString stringWithFormat:@"%@/shop/push/register",SERVERURI]

//옵션정보
#define GSOPTIONINFOURL [NSString stringWithFormat:@"%@/apis/v2.6/member/setting",SERVERURI]

//SKT유저체크
#define GSSKTUSERCHECKURL [NSString stringWithFormat:@"/app/FreeDataPopup"]

//인트로 이미지
#define GSINTROURL [NSString stringWithFormat:@"/app/intro/image"]

//마이쇼핑 알림함 리얼맴버쉽
#define GS_MYSHOP_PERSONINFO [NSString stringWithFormat:@"/app/customer/rlmemshp.gs"]

//사이렌 링크
#define GSSIRENURL [NSString stringWithFormat:@"%@/event/siren/empSirenDeclr.jsp?appver=%@",SERVERURI,CURRENTAPPVERSION]

//TV편성표 매장 생방송정보 불러오기
#define GS_TVSCHEDULE_LIVEINFO [NSString stringWithFormat:@"/main/liveBroadInfo"]
//TV편성표 매장 알람 정보요청
#define GS_TVSCHEDULE_ALARMINFO [NSString stringWithFormat:@"%@/app/broad/alarm/addPage",SERVERURI]
//TV편성표 매장 알람 등록
#define GS_TVSCHEDULE_ALARMADD [NSString stringWithFormat:@"%@/app/broad/alarm/add",SERVERURI]
//TV편성표 매장 알람 삭제
#define GS_TVSCHEDULE_ALARMDELETE [NSString stringWithFormat:@"%@/app/broad/alarm/selectDelete",SERVERURI]

#define TVS_ALARMINFO @"INFO"
#define TVS_ALARMADD @"ADD"
#define TVS_ALARMDELETE @"DELETE"

//날방 채팅 입력
#define NALBANGHIDDENCHATOBSERVERN @"NALBANGHIDDENCHATOBSERVERN"
#define NALBANGHIDDENCHATOBSERVERY @"NALBANGHIDDENCHATOBSERVERY"

//라이브톡 채팅 입력
//날방 채팅 입력
#define LIVETALK_HIDDEN_CHAT_OBSERVER_N @"LIVETALKHIDDENCHATOBSERVER_N"
#define LIVETALK_HIDDEN_CHAT_OBSERVER_Y @"LIVETALKHIDDENCHATOBSERVER_Y"


#define GSNALCHATURL(roomnum) [NSString stringWithFormat:@"%@/app/section/nalbang/talk/%@/write", SERVERURI, roomnum]

// MobileLive new gatepage
#define GSMOBILELIVE_GATEPAGE [NSString stringWithFormat:@"%@/section/mobilelive?onAirInfo=Y", SERVERURI]

//라이브톡 글쓰기
#define GSLIVETALKURL(roomnum) [NSString stringWithFormat:@"%@/app/section/livetalk/talk/%@/write", SERVERURI, roomnum]


//##################### WEB URL DEFINE #################################
//로그인이 필요한 페이지에서 넘어오는 주소
#define  GSLOGINCHECKURL [NSString stringWithFormat:@"toapp://login"]
//로그아웃 전용 주소
#define GSLOGOUTTOAPPURL [NSString stringWithFormat:@"toapp://logout"]


//API linkurl openURL 전용 검사용
#define GSEXTERNLINKPROTOCOL [NSString stringWithFormat:@"external://"]


//와이즈로그 lseq 추가 및 추가 API 2013-08-08
/*
 typedef enum  {
 ReqWISELOGMAINLOGOURL,
 ReqWISELOGMAINSEARCHEVENTURL,
 ReqWISELOGSEARCHEVENTURL,
 ReqWISELOGSEARCHTABURL,
 ReqWISEETC,
 } WISELogReqType;
 */

typedef enum  {
    TYPE_SMSMESSAGE,
    TYPE_KAKAOTALK,
    TYPE_KAKAOSTORY,
    TYPE_FACEBOOK,
    TYPE_TWITTER,
    TYPE_LINE,
    TYPE_SHARE,
    TYPE_URLCOPY,
} TYPEOFSNS;

//KAKAO 네이티브앱키
#define KAKAONATIVEAPPKEY [NSString stringWithFormat:@"kakao891cea206a1ce9af85341bb32ca1e37f://kakaolink?url="]
#define KAKAONATIVEAPPKEY2 [NSString stringWithFormat:@"kakaoc4cac3d2f71f88a02b45651f32383b5a://kakaolink?url="]

#define APPLEIDCREDENTIALKEY    @"gsshopAppleIDCredential"

//메인-홈http://mt.gsshop.com/test/applinktest.jsp
#define GSMAINURL [NSString stringWithFormat:@"%@/index.gs",SERVERURI]

#define WISELOGGSMAINURL [NSString stringWithFormat:@"%@/index.gs?fromApp=Y",SERVERURI]

//0=홈 1=카테고리 2-검색 3-스마트카트
//카테고리
#define SecondURL [NSString stringWithFormat:@"%@/m/sect/category.gs?mseq=398050&fromApp=Y&_=%lf",SERVERURI, [[NSDate date] timeIntervalSinceReferenceDate]]


//#define GSMAINURL [NSString stringWithFormat:@"%@/test/applinktest.jsp",SERVERURI]
//스마트카트 치명
#define SMARTCART_URL [NSString stringWithFormat:@"%@/mobile/cart/viewCart.gs?mseq=398045&fromApp=Y",SERVERURI]
#define SMARTCART_GSFRESH_URL [NSString stringWithFormat:@"%@/mobile/cart/viewCart.gs?mseq=398045&fromApp=Y&cartTabId=mart",SERVERURI]

//카테고리 20200728 parksegun
#define CATEGORY_URL [NSString stringWithFormat:@"%@/m/sect/category.gs?mseq=",SERVERURI]

//찜
#define WISH_URL [NSString stringWithFormat:@"%@/section/myWishMain.gs?mseq=410808&fromApp=Y",SERVERURI]

//최근 본 상품
#define HISTORY_URL [NSString stringWithFormat:@"%@/section/recntView?mseq=410809&fromApp=Y",SERVERURI]

//주문배송
#define MYORDER_URL [NSString stringWithFormat:@"%@/mygsshop/myOrderList.gs?mseq=398053&fromApp=Y",SERVERURI]

//나의쇼핑
// [19.06.24] kiwon : 마이쇼핑 URL을 HTTPS로 변경
#define MYSHOP_URL [NSString stringWithFormat:@"%@/mygsshop/myshopInfo.gs?mseq=398041&fromApp=Y",SERVERURI_HTTPS]

//하단 FOOTER 사용 URL
//이용약관
#define MANUALGUIDEFOOTERURL [NSString stringWithFormat:@"%@/m/mygsshop/articleMain.gs?fromApp=Y",SERVERURI]

//결제안내
#define PAYGUIDEIPHONEFOOTERURL [NSString stringWithFormat:@"%@/m/mygsshop/payGuideIphoneApp.gs?gsid=MCfooter&fromApp=Y",SERVERURI]

//고객센터
#define CUSTOMERCENTERFOOTERURL [NSString stringWithFormat:@"%@/mygsshop/customerCenter.gs?gsid=MCfooter&fromApp=Y",SERVERURI]

//개인정보 취급방침
#define PRIVATEINFOFOOTERURL [NSString stringWithFormat:@"%@/m/mygsshop/articleProtect.gs?div=person&gsid=MCfooter&fromApp=Y",SERVERURI]

//청소년 보호정책
#define TEENAGERPOLICYFOOTERURL [NSString stringWithFormat:@"%@/m/mygsshop/articleProtect.gs?div=youth&gsid=MCfooter&fromApp=Y",SERVERURI]

//공지사항
#define GSNOTICEFOOTERURL [NSString stringWithFormat:@"%@/mygsshop/notice.gs?mseq=411855",SERVERURI]
//고객서비스
#define GSSERVICEFOOTERURL [NSString stringWithFormat:@"%@/m/mygsshop/qnaMain.gs?mseq=411850",SERVERURI]

//앱 업데이트URL -openurl
#define UPDATENEWVERSIONURL @"https://itunes.apple.com/kr/app/gsshop/id365438600?mt=8"
//단축 url : http://appstore.com/gsshop/gsshop
// appstore.com/개발사명/개별앱  개발사명까지만 호출시 해당개발사가 배포한 앱 리스트화면으로 link.

//로그인창 URL link 2종
//아이디찾기
// nami0342 - SSL
#define  GSLOGINFINDIDURL [NSString stringWithFormat:@"%@/member/memberIDSearch.gs?fromApp=Y",SERVERURI]


//비밀번호 찾기
// nami0342 - SSL
#define  GSLOGINFINDPWURL [NSString stringWithFormat:@"%@/member/memberPasswordSearch.gs?fromApp=Y",SERVERURI]


//비회원배송조회
// nami0342 - SSL
#define NONMEMBERORDERLISTURL(__C1__)  [NSString stringWithFormat:@"%@/member/noMemberOrderList.gs?fromApp=Y&returnurl=%@",SERVERURI_HTTPS,[__C1__ urlEncodedString]]


//비회원주문
#define NONMEMBERORDERURL(__C1__)  [NSString stringWithFormat:@"%@/member/certifyNoMember.gs?fromApp=Y&returnurl=%@",SERVERURI_HTTPS,[__C1__ urlEncodedString]]

//성인인증화면
#define ADULTAUTHURL(__C1__)  [NSString stringWithFormat:@"%@/member/adultCheck.gs?fromApp=Y&returnurl=%@",SERVERURI,[__C1__ urlEncodedString]]

//휴대폰로그인
#define  GSFINDLOGINWITHPHONEURL(__C1__) [NSString stringWithFormat:@"%@/member/loginMcctCert.gs?titleNm=mcct&fromApp=Y&returnurl=%@",SERVERURI_HTTPS, [__C1__ urlEncodedString]]

//TV로그인
#define TVUSERLOGIN(__C1__) [NSString stringWithFormat:@"%@/member/tvLogIn.gs?returnurl=%@",SERVERURI_HTTPS,[__C1__ urlEncodedString]]


//회원가입주소 -20140801 변경됨
#define JOINURL [NSString stringWithFormat:@"%@/ipin/sendIpinRequestPop.gs?fromApp=Y",SERVERURI]

//인증이메일재발송
// nami0342 - SSL
#define GSEMAILAUTHURL [NSString stringWithFormat:@"%@/cert/emailCert/form.gs?fromApp=Y",SERVERURI]

//고객센터
#define GSCUSTOMERCENTERURL [NSString stringWithFormat:@"%@/mygsshop/customerCenter.gs?fromApp=Y",SERVERURI]

//약관 - 개인정보 처리 방침 공용
#define GSRULEURL [NSString stringWithFormat:@"%@/m/mygsshop/articleMain.gs?fromApp=Y",SERVERURI]

//회사소개
#define GSCOMPANYINTROEURL [NSString stringWithFormat:@"%@/m/mygsshop/companyInfo.gs?fromApp=Y",SERVERURI]

//회원탈퇴
#define GSLEAVEGSMEMBERURL  [NSString stringWithFormat:@"%@/member/personInfoManagement.gs?isWthdr=Y&fromApp=Y",SERVERURI]

//회원탈퇴 완료 주소 StrContain 으로 처리
#define GS_LEAVEGSMEMBER_FININSH_URL  @"/member/withdrawalGSShopAndGSnPoint.gs"


//VOD 상품 단품URL  - VOD동영상제생 - 현재상품 버튼 링크용
#define VODPRDDETAILURL [NSString stringWithFormat:@"%@/prd/prd.gs?fromApp=Y&prdid=",SERVERURI]


//푸터 -채무지급보증 URL
#define GSCOMPANYGUARANTEEURL [NSString stringWithFormat:@"%@/mobile/etc/etc_loan.jsp",SERVERURI]


//푸터 -사업자정보 URL
#define GSCOMPANYINFOTURL [NSString stringWithFormat:@"%@",@"http://www.ftc.go.kr/bizCommPop.do?wrkr_no=1178113253"]


//단품 상단 네이티브 구성용 API
#define PRODUCT_NATIVE_TOP [NSString stringWithFormat:@"%@/product/api/",SERVERURI]
//단품 상단 네이티브용 하단 웹뷰 url
#define PRODUCT_NATIVE_BOTTOM_URL @"/product/nativeApp.gs"
//딜 상단 네이티브 구성용 API
#define DEAL_NATIVE_TOP [NSString stringWithFormat:@"%@/deal/api/",SERVERURI]
//딜 상단 네이티브용 하단 웹뷰 url
#define DEAL_NATIVE_BOTTOM_URL @"/deal/nativeApp.gs"
#define PRODUCT_NATIVE_CARTUPDATE @"PRODUCT_NATIVE_CARTUPDATE"


//##################### 결제 URL DEFINE #################################
//ISP url
#define GSISPRECVURL(url) [NSString stringWithFormat:@"%@/mobile/order/main/preISPConfirmOrder.gs?%@",SERVERURI,url]
#define GSISPDOWNURL @"https://itunes.apple.com/kr/app/id369125087?mt=8" //ISP 미설치시에 이동하는 주소
#define GSISPFAILBACKURL [NSString stringWithFormat:@"%@/order/main/normalRegiShip.gs",SERVERURI]//ISP에서 주문 취소시에 주문페이지로 이동 하는 주소

//Paynow url
#define GSPAYNOWRECVURL(url) [NSString stringWithFormat:@"%@/mobile/order/paynow/prePaynowConfirmOrder.gs?%@",SERVERURI,url]


// start 2012.02.09 신한 안심 클릭 url start
#define SHINHANDOWNURL @"https://itunes.apple.com/us/app/id360681882?mt=8"
#define SHINHANAPPNAME @"smshinhanansimclick"
// end 2012.02.09 신한 안심 클릭 url end

// start 2013.09.10 신한Mobile 앱 다운로드 url start
#define SHINHANMAPPDOWNURL @"https://itunes.apple.com/kr/app/sinhan-mobilegyeolje/id572462317?mt=8"
#define SHINHANAPPCARDAPPNAME @"shinhan-sr-ansimclick"
// end 2013.09.10 신한Mobile 앱 다운로드 url end

//start 2012.06.25 현대 안심 클릭 url start
#define HYUNDAIDOWNURL @"https://itunes.apple.com/kr/app/id362811160?mt=8"
#define HYUNDAIAPPNAME @"smhyundaiansimclick"
//end 2012.06.25 현대 안심 클릭 url end0


//start 2015.09.25 PAYNOW url start
#define PAYNOWDOWNURL @"https://itunes.apple.com/kr/app/paynow/id760098906?l=en&mt=8"
#define PAYNOWAPPNAME @"lguthepay"
//end 2015.09.25 PAYNOW url end


//start 2014.11.20  url start
#define LOTTEMOBILECARDAPPNAME @"lottesmartpay"
#define LOTTEAPPCARDAPPNAME @"lotteappcard"
//end  2014.11.20 lotte 모바일결제, 앱카드 url end


// start 2015.04.06 KB Mobile 앱카드 다운로드 url start
#define KBMAPPDOWNURL @"https://itunes.apple.com/kr/app/kbgugmin-aebkadeu/id695436326?mt=8"
#define KBAPPCARDAPPNAME @"kb-acp://"
// end 2015.04.06 KB Mobile 앱카드 앱 다운로드 urql end -v3.1.3.14


//js파일 경로
#define JSSELECTPATH [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JStool" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil]

//동영상 재생시 Alert문구 정의
#define DATASTREAM_ALERT GSSLocalizedString(@"network_billing_confirm")

//App접속장애시 Alert문구 정의
#define GNET_DISCONNECTED GSSLocalizedString(@"network_disconnected")
#define GNET_SERVERDOWN GSSLocalizedString(@"network_down")

//웹페이지 로딩시 넷연결 불능시
#define GNET_UNSTABLE GSSLocalizedString(@"network_unstable")
//네트워크 사용시 서버에러가 발생하는 경우 = Mocha NetworkOperation 에서 alert 담당.
#define GNET_ERRSERVER GSSLocalizedString(@"error_server")



//추천 연관 검색어 URL
#define RECOMMENDED_RELATED_SEARCH_TERMS [NSString stringWithFormat:@"%@/app/shop/main/search/extentionKeyWord",SERVERURI]




//로그아웃 Alert msg
#define  LOGOUTALERTALSTR  GSSLocalizedString(@"login_confirm_logout")
#define  LOGOUTCONFIRMSTR1  GSSLocalizedString(@"common_txt_alert_btn_cancel")
#define  LOGOUTCONFIRMSTR2  GSSLocalizedString(@"common_txt_alert_btn_confirm")


//단말 높이를 이용한 단말 추출
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)

#define IS_PLUS_OR_MAX (IS_IPHONE && SCREEN_WIDTH >= 414.0)

// nami0342 - 아이폰 X 판단 -> 아이폰 XS, XR, XS max 대응 추가
#if TARGET_OS_SIMULATOR || TARGET_IPHONE_SIMULATOR
#define IS_IPHONE_X_SERISE ((SCREEN_MAX_LENGTH == 812.0 || SCREEN_MAX_LENGTH == 896.0) && IS_IPHONE)
#else
// 812.0 on iPhone X, XS. 896.0 on iPhone XS Max, XR. X serise 대응으로 적용 해야 하나.
#define IS_IPHONE_X_SERISE ((SCREEN_MAX_LENGTH == 812.0 || SCREEN_MAX_LENGTH == 896.0) && IS_IPHONE)
#endif

//ststusbar 높이
#define STATUSBAR_HEIGHT (IS_IPHONE_X_SERISE ? 49.0 : 20.0)



//##################### 참고용도 #################################
//GSSHOP최신버전정보가져오기 JSON
//http://itunes.apple.com/lookup?id=365438600
//GSSHOP앱스토어 앱화면으로 이동URL
//http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=365438600
//http://itunes.apple.com/kr/app/id365438600
//http://itunes.apple.com/kr/app/gsshop/id365438600?mt=8&uo=4

//설치URL 참조용
//http://itunes.apple.com/kr/app/gsshop/id365438600?mt=8
//별점
//http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=365438600&type=Purple+Software&mt=8
//업데이트버전 URL
//itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=[APPID]&mt=8

//post comm 관련


// test code 20140108 -Youngmin Jin Start
#define DATA(X)    [X dataUsingEncoding:NSUTF8StringEncoding]
// test code 20140108 -Youngmin Jin ENd
// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"prdRevwImage\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"

#define IMAGE_CONTENT_MULTI @"Content-Disposition: form-data; name=\"prdRevwImage\"; filename=\"review_ios_%d.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"

#define MP4_CONTENT @"Content-Disposition: form-data; name=\"file\"; filename=\"iOSmedia.mp4\"\r\nContent-Type: video/mp4\r\n\r\n"


#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define URLENCODEDFORMHEAD @"application/x-www-form-urlencoded"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"
#define EVTIMAGE_CONTENT @"Content-Disposition: form-data; name=\"img_upload_file\"; filename=\"eventimage.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"

//메인 섹션 carouselview 관련 NSNotification 등록
//메인섹션 전체 api통신후 재적재 화면로딩 후 상단으로
#define MAINSECTIONGOTOPNRELOADNOTI @"MAINSECTIONGOTOPNRELOADNOTI"
//섹션 헤더뷰 TVC 일경우 TV컨텐츠 api통신 후 재적재

//PUSHAPNS 수신 후 메인 icarouselview 생성완료후 섹션 이동 noti
#define MAINSECTIONPUSHMOVENOTI @"MAINSECTIONPUSHMOVENOTI"



//wk웹뷰 세션성공 실패 노티
#define WKSESSION_SUCCESS @"WKSESSION_SUCCESS"
#define WKSESSION_FAIL @"WKSESSION_FAIL"

#define WKSESSION_REINIT @"WKSESSION_REINIT"

//WK웹뷰에서 카피 해 와야하는 쿠키이름정의
#define WKCOOKIE_NAME_CART @"cartcnt"
#define WKCOOKIE_NAME_GSSUPER @"gssuper"
#define WKCOOKIE_NAME_LASTPRDID @"lastprdid"


//베스트딜 동영상 플레이어를 pause 한 노티 , Home_Main_ViewController 를 바로 참조 못하는 컨트롤러 처리용
#define MAINSECTIONDEALVIDEOPAUSENOTI @"MAINSECTIONDEALVIDEOCHECKNOTI"
#define MAINSECTIONDEALVIDEOALLKILL @"MAINSECTIONDEALVIDEOALLKILL"


//하단 탭바들의 상태업데이트를 위한 노티
#define BOTTOM_TABBAR_BADGE_UPDATE @"BOTTOM_TABBAR_UPDATE"
#define BOTTOM_TABBAR_LASTPRD_UPDATE @"BOTTOM_TABBAR_LASTPRD_UPDATE"

//2016.01 라이브 동영상 올킬추가
#define MAINSECTIONLIVEVIDEOALLKILL @"MAINSECTIONLIVEVIDEOALLKILL"

//2017.06 TV편성표 매장 동영상 킬 추가
#define SCHEDULELIVEVIDEOALLKILL @"SCHEDULELIVEVIDEOALLKILL"

//로그인시 사이렌 버튼을 노출할지 여부 노티
#define MAINSECTIONHIDEBUTTONSIREN @"MAINSECTIONHIDEBUTTONSIREN"

//바로구매창 닫힘 노티
#define MAINSECTIONDIRECTORDERCLOSE @"MAINSECTIONDIRECTORDERCLOSE"
//SNS공유창 닫힘 노티
#define MAINSECTIONSNSSHARECLOSE @"MAINSECTIONSNSSHARECLOSE"

//매장 API 완료 노티
#define MAINSECTION_API_FINISH @"MAINSECTION_API_FINISH"

//홈 듀얼AB 프레임사라짐 노티
#define MAINSECTION_DUAL_AB_PAUSE @"MAINSECTION_DUAL_AB_PAUSE"

//홈 헤더 동영상뷰 3G 알럿 제거노티
#define MAINSECTION_MOVIE_3G_ALERT @"MAINSECTION_MOVIE_3G_ALERT"

//2019.04 VOD동영상 매장 올킬
#define MAINSECTION_VODVIDEOALLKILL @"MAINSECTION_VODVIDEOALLKILL"
#define MAINSECTION_VODVIDEOPAUSE @"MAINSECTION_VODVIDEOPAUSE"
#define MAINSECTION_VODVIDEOPAUSE_NOTME @"MAINSECTION_VODVIDEOPAUSE_NOTME"
#define MAINSECTION_VODVIDEOAUTOPLAY_PAUSE @"MAINSECTION_VODVIDEOAUTOPLAY_PAUSE"

//2019.04 글로벌 사운드 처리용 노티
#define GS_GLOBAL_SOUND_CHANGE @"GS_GLOBAL_SOUND_CHANGE"

//2019.08
#define HOME_MAINSECTION_FIRSTPROC @"HOME_MAINSECTION_FIRSTPROC"

#define SECTIONCODE_HOME @"#396185"
#define SECTIONCODE_TVSHOP @"#396184"
#define SECTIONCODE_VOD @"#181818"

//여기부터
//개별 섹션 화면정의를 위한 pix fix
#define kMinusCenterHeight 108
#define APPTABBARHEIGHT  (IS_IPHONE_X_SERISE ? 80.0 : 50.0) //아이폰엑스는 하단 안전영역 30을 먹고 들어간다.


//UserDefault Key ex) data=2014-06-23
#define PROMOTIONPOPUPDATE @"PromotionSaveDate"
//앱 lifecycle동안 1회보장 -닫기버튼 눌렀을경우 해당 세션에서는 더이상 않봄 int 1 or 0
#define PROMOTIONPOPUPISDENY @"PromotionPopupDeny"

//2018.02.01 푸시수신동의 유도 프로모션 팝업
#define PROMOTIONPOPUP_PUSHAGREE_NO7DAY @"PROMOTIONPOPUP_PUSHAGREE_NO7DAY"

//2018.04.05 매장 개인화 팝업
#define PERSONALPOPUP_ARR_NOLOOK @"PERSONALPOPUP_ARR_NOLOOK"
#define PERSONALPOPUP_DIC_TOMORROW @"PERSONALPOPUP_DIC_TOMORROW"
#define PERSONALPOPUP_KEY_DSPLSEQ @"dsplSeq"
#define PERSONALPOPUP_KEY_CONFIRM_DATE @"confirm_date"
#define PERSONALPOPUP_KEY_ARR_DSPLSEQ @"ARR_dsplSeq"

//Pinterest ID
#define PINTERESTSDK_APPID @"4938747573920872852"       // nami0342 - ym.m@gsshop.com 계정

// Naver SDK
#define naverServiceAppUrlScheme    @"gsshopmobile"

#define naverConsumerKey            @"lKFdFcYB3_zG0kl3EjH6"
#define naverConsumerSecret         @"GXvuKrulRq"
#define naverServiceAppName         @"gsshop"


//베스트딜 동영상 자동플레이 플래그 by yunsang.jin
#define BESTDEAL_AUTOPLAYMOVIE @"BESTDEAL_AUTOPLAYMOVIE"

//INTROIMAGE by yunsang.jin
#define DIC_SPLASH @"DIC_SPLASH"
#define DIC_SPLASH_TXT @"appIntroTxt"

//숏방 가이드 화면 노출 여부
#define SHORTBANGGUIDE @"SHORTBANGGUIDE"

//최근 검색어, 최근 본 상품 쿠기값을 저장하기 위한 키
#define GS_SAVECOOKIE @"GS_SAVECOOKIE"

//GS SUPER 토스트 팝업
#define GS_SUPER_TOAST @"GS_SUPER_TOAST"
//GS SUPER 툴팁
#define GS_SUPER_TOOLTIP @"GS_SUPER_TOOLTIP"

//family site
#define FAMILY_10X10 @"https://m.10x10.co.kr"
#define FAMILY_NPOINT @"https://m.gsnpoint.com"
#define CUSTOMCENTER_TEL @"tel://1899-4455"
#define MEMBERCENTER_TEL @"tel://1899-4500"

//정보통신법 개정안
#define INFOCOMMLAW_URL [NSString stringWithFormat: @"%@/app/main/personalChk",SERVERURI]
#define INFOCOMMLAW_SHOW @"infocommlawshow"
#define INFOCOMMLAW_DATA_SEND @"infocommlawdatasend"
#define INFOCOMMLAW_FLAG_VERSION @"3.5.1" // 주소록 권한 추가

//fingerprint
#define FINGERPRINT_USE_KEY @"fingerprint"
#define INFOFINGERPRINTSUGGEST @"Info_fingerprint_suggest"

// CSP
#if !APPSTORE
#if DEBUG
#define CPS_SERVER_STATUS_URL @"http://image.gsshop.com/ui/stage/gsshop/event/csp/check.html"
#else
// Release
#define CPS_SERVER_STATUS_URL @"http://image.gsshop.com/ui/gsshop/event/csp/check.html"
#endif
#else
// Release
#define CPS_SERVER_STATUS_URL @"http://image.gsshop.com/ui/gsshop/event/csp/check.html"
#endif

#define BAN_SLD_GBD_CHECK @"BAN_SLD_GBD_CHECK"


#define NOTI_CSP_START_SOCKET @"noti_csp_start_socket"
#define NOTI_CSP_STOP_SOCKET @"noti_csp_stop_socket"
#define NOTI_CSP_SHOW_MESSAGES @"noti_csp_show_messages"
#define NOTI_CSP_ALL_CLEAR @"noti_csp_all_clear"

#define BRIGHTCOVE_ACCOUNTID @"5819061489001"
#define BRIGHTCOVE_POLICY_KEY @"BCpkADawqM1-nZroB0DBQvcLk1NDRIiwWXoXx5uwntK19LCTuk1F2Vdf32rfocwf8VOcwPIxEFRrXDFZBLU7W3Nrh-37vE4qlV7y6BAdRiCOPs1LT0Gp-GxeaQd-63WPja-zwwdIFA3J2QB_"


// 치명 확인사항
// 1. 스키마에디트 - Run - 옵션 - application language = KOREAN to system..
// 2. build setting - general = UNIVERSAL?
// 3. newrelic 추가시 targets-GSSHOP - Build Phases 탭 - Run Script 아랫두줄 추가
// SCRIPT=`/usr/bin/find "${SRCROOT}" -name newrelic_postbuild.sh | head -n 1`
// /bin/sh "${SCRIPT}" "AA2658fda12b78638eaaec7c22e1c9005e1170f351"


