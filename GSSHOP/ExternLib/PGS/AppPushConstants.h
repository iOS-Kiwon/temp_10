
//COLLECT DATA
#define APPPUSH_DEF_SEPARATE_CLICK              @"||"
#define APPPUSH_DEF_READ_MSG                    @"AMAIL_APPPUSH_DEF_SAVE_READ_MSG"
#define APPPUSH_DEF_CLICK_MSG                   @"AMAIL_APPPUSH_DEF_SAVE_CLICK_MSG"

//NOTIFICATION
#define APPPUSH_DEF_NOTI_SHOW_MAIN              @"AMAIL_APPPUSH_DEF_NOTI_SHOW_MAIN"
#define APPPUSH_DEF_NOTI_RECEIVE_MESSAGE        @"AMAIL_APPPUSH_DEF_NOTI_RECEIVE_MESSAGE"
#define APPPUSH_DEF_NOTI_REDEVICE_CERT          @"AMAIL_APPPUSH_DEF_NOTI_REDEVICE_CERT"
#define APPPUSH_DEF_NOTI_START_CERT             @"AMAIL_APPPUSH_DEF_NOTI_START_CERT"
#define APPPUSH_DEF_NOTI_SET_THEME              @"AMAIL_APPPUSH_DEF_NOTI_SET_THEME"
//DATA
#define APPPUSH_DEF_CERT_NOT                    0
#define APPPUSH_DEF_CERT_LOADING                1
#define APPPUSH_DEF_CERT_DONE                   2

#define APPPUSH_DEF_MSG_FLAG                    @"AMAIL_APPPUSH_DEF_MSG_FLAG"
#define APPPUSH_DEF_NOTI_FLAG                   @"AMAIL_APPPUSH_DEF_NOTI_FLAG"
#define APPPUSH_DEF_APNS_TOKEN                  @"AMAIL_APPPUSH_DEF_APNS_TOKEN"
#define APPPUSH_DEF_USER_OLD_ID                 @"AMAIL_APPPUSH_DEF_USER_OLD_ID"
#define APPPUSH_DEF_USER_ID                     @"AMAIL_APPPUSH_DEF_USER_ID"
#define APPPUSH_DEF_DEVICE_ID                   @"AMAIL_APPPUSH_DEF_DEVICE_ID"
#define APPPUSH_DEF_WA_PC_ID                    @"AMAIL_APPPUSH_DEF_WA_PC_ID"
#define APPPUSH_DEF_GA_ID                       @"AMAIL_APPPUSH_DEF_GA_ID"
#define APPPUSH_DEF_PC_ID                       @"AMAIL_APPPUSH_DEF_PC_ID"
#define APPPUSH_DEF_UNIQUE_DATE                 @"AMAIL_APPPUSH_DEF_UNIQUE_DATE"
#define APPPUSH_DEF_RETAIN_FLAG                 @"AMAIL_APPPUSH_DEF_RETAIN_FLAG"
#define APPPUSH_DEF_UUID                        @"AMAIL_APPPUSH_DEF_UUID"
#define APPPUSH_DEF_NETWORK_KEY                 @"AMAIL_APPPUSH_DEF_NETWORK_KEY"
#define APPPUSH_DEF_APP_USER_ID                 @"AMAIL_APPPUSH_DEF_APP_USER_ID"
#define APPPUSH_DEF_NEW_MSG_COUNT               @"AMAIL_APPPUSH_DEF_NEW_MSG_COUNT"
#define APPPUSH_DEF_NEW_RECEIVE_MESSAGE         @"AMAIL_APPPUSH_DEF_NEW_RECEIVE_MESSAGE"
#define APPPUSH_DEF_READ_MESSAGE                @"AMAIL_APPPUSH_DEF_READ_MESSAGE"
#define APPPUSH_DEF_USER_CRM                    @"AMAIL_APPPUSH_DEF_USER_CRM"

//LoadingView
#define APPPUSH_DEF_LOADING_TEXT                @"로딩중..."

//color set
#define AMAIL_RGB_DEFAULT                   [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f]
#define AMAIL_RGB(r,g,b)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define AMAIL_UIColorFromRGB(rgbValue)      [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//MSG TYPE
#define MSG_TYPE_TEXT               @"T"
#define MSG_TYPE_ATTACH             @"A"
#define MSG_TYPE_HTML               @"H"
#define MSG_TYPE_URL                @"L"
#define MSG_TYPE_IMAGE              @"I"

//DB COLUMN
#define AMAIL_MSG_ID            @"_ID"
#define AMAIL_MSG_TITLE         @"TITLE"
#define AMAIL_MSG_MSG           @"MSG"
#define AMAIL_MSG_MAP1          @"MAP1"
#define AMAIL_MSG_MAP2          @"MAP2"
#define AMAIL_MSG_MAP3          @"MAP3"
#define AMAIL_MSG_APP_LINK      @"APP_LINK"
#define AMAIL_MSG_ICON_NAME     @"ICON_NAME"
#define AMAIL_MSG_MSG_CODE      @"MSG_CODE"
#define AMAIL_MSG_MSG_ID        @"MSG_ID"
#define AMAIL_MSG_COMMON_MSG_ID @"COMMON_MSG_ID"
#define AMAIL_MSG_MSG_TYPE      @"MSG_TYPE"
#define AMAIL_MSG_ATTACH_INFO   @"ATTACH_INFO"
#define AMAIL_MSG_IMG_DELIMITER @","
#define AMAIL_MSG_READ_YN       @"READ_YN"
#define AMAIL_MSG_EXP_DATE      @"EXP_DATE"
#define AMAIL_MSG_REG_DATE      @"REG_DATE"
#define AMAIL_MSG_IMG           @"PUSH_IMG"
#define AMAIL_MSG_UID           @"MSG_UID"
#define AMAIL_MSG_APP_USER_ID   @"MSG_APP_USER_ID"
#define AMAIL_MSG_OWNER         @"MSG_OWNER"


//NETWORK

#define APPPUSH_NETWORK_SUCCESS_CODE                    @"000"
#define APPPUSH_NETWORK_ALREADY_READ_CODE               @"550"
#define APPPUSH_NETWORK_ERROR_CODE                      @"902"

#define APPPUSH_NETWORK_CIPHER                          @"CIPHER"
#define APPPUSH_NETWORK_UNCIPHER                        @"UNCIPHER"
//base Cover
#define APPPUSH_NOTI_DEFAULT_ARGS                       @"{\"id\":\"%@\",\"data\":\"%@\"}"
//GSShop API
#define APPPUSH_NOTI_GSSHOP                             @"APPPUSH_NOTI_GSSHOP"
// DeviceCert
#define APPPUSH_NOTI_DEVICE                             @"APPPUSH_NOTI_DEVICE"
#define APPPUSH_DEVICE_PARAM_ARGS                       @"{\"os\":\"I\",\"custId\":\"%@\",\"deviceUid\":\"%@\",\"waPcId\":\"%@\",\"pushToken\":\"%@\",\"osVer\":\"%@\",\"appVer\":\"%@\",\"device\":\"%@\",\"uuid\":\"%@\",\"appKey\":\"%@\",\"advrId\":\"%@\",\"pcId\":\"%@\"}"
#define APPPUSH_DEVICE_PARAM_USER_INFO_ARGS             @"{\"os\":\"I\",\"custId\":\"%@\",\"deviceUid\":\"%@\",\"waPcId\":\"%@\",\"pushToken\":\"%@\",\"osVer\":\"%@\",\"appVer\":\"%@\",\"device\":\"%@\",\"uuid\":\"%@\",\"appKey\":\"%@\",\"userData\":%@,\"advrId\":\"%@\",\"pcId\":\"%@\"}"
// NewMsg
#define APPPUSH_NOTI_NEW_MESSAGE                        @"APPPUSH_NOTI_NEW_MESSAGE"
#define APPPUSH_NOTI_NEW_MESSAGE_PARAM_ARGS             @"{\"type\":\"%@\",\"reqUserMsgId\":\"%@\",\"msgGrpCd\":\"%@\",\"pageInfo\":{\"page\":\"%d\",\"row\":\"%d\"}}"
// ReadMsg
#define APPPUSH_NOTI_READ_MESSAGE                       @"APPPUSH_NOTI_READ_MESSAGE"
#define APPPUSH_NOTI_READ_MESSAGE_PARAM_ARGS            @"{\"userMsgIds\":[%@]}"
// ClickMsg
#define APPPUSH_NOTI_CLICK_MESSAGE                      @"APPPUSH_NOTI_CLICK_MESSAGE"
#define APPPUSH_NOTI_CLICK_MESSAGE_PARAM_ARGS           @"{\"clicks\":[%@]}"
// Set Config
#define APPPUSH_NOTI_SET_CONFIG                         @"APPPUSH_NOTI_SET_CONFIG"
#define APPPUSH_NOTI_SET_CONFIG_PARAM_ARGS              @"{\"msgFlag\":\"%@\",\"notiFlag\":\"%@\"}"
//Login
#define APPPUSH_NOTI_LOGIN                              @"APPPUSH_NOTI_LOGIN"
#define APPPUSH_NOTI_LOGIN_PARAM_ARGS                   @"{\"custId\":\"%@\"}"
#define APPPUSH_NOTI_LOGIN_PARAM_USER_INFO_ARGS         @"{\"custId\":\"%@\",\"userData\":%@}"
//Logout
#define APPPUSH_NOTI_LOGOUT                             @"APPPUSH_NOTI_LOGOUT"
#define APPPUSH_NOTI_LOGOUT_PARAM_ARGS                  @"{\"custId\":\"%@\"}"

//105Test
#define APPPUSH_NOTI_SESSION_OUT                        @"APPPUSH_NOTI_SESSION_OUT"
#define APPPUSH_NOTI_SESSION_OUT_PARAM_ARGS             @"{\"a\":\"a\"}"






///// GSSHOP START /////

//PUSH TIME
#define PUSH_START              1
#define PUSH_FORE               2
#define PUSH_BACK               3

//HOME
#define GSSHOP_HOME_URL         @"home://"

//POPUP SIZE
#define AMAIL_POPUP_WIDTH       280.0f
#define AMAIL_POPUP_HEIGHT      150.0f

//URL IMAGE TYPE
#define AMAIL_URL_IMAGE_TYPE    @"png",@"jpg",@"gif"

///// GSSHOP START /////

