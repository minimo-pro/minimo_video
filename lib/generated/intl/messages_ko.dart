// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko';

  static String m0(prefix) => "\"${prefix}\" 접두사 추가";

  static String m1(prefix) =>
      "원본 파일 이름 앞에 \"${prefix}\"를 추가합니다. 끄면 원본 이름을 유지합니다";

  static String m2(version) => "${version} 새 기능";

  static String m3(count) =>
      "${Intl.plural(count, one: '약 1분 남음', other: '약 ${count}분 남음')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '동영상 1개 저장', other: '동영상 ${count}개 저장')}";

  static String m5(album) => "압축한 동영상을 최근 저장 항목 대신 ${album} 앨범에 저장합니다";

  static String m6(error) => "동영상은 저장되었지만 일부 원본을 삭제할 수 없습니다: ${error}";

  static String m7(saved, deleted) =>
      "동영상 ${saved}개를 저장하고 원본 ${deleted}개를 삭제했습니다";

  static String m8(count) =>
      "${Intl.plural(count, one: '동영상 1개를 갤러리에 저장했습니다', other: '동영상 ${count}개를 갤러리에 저장했습니다')}";

  static String m9(error) => "일부 문제와 함께 동영상이 저장되었습니다: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: '약 1초 남음', other: '약 ${count}초 남음')}";

  static String m11(url) =>
      "휴대폰에서 동영상을 간단히 줄여주는 minimo (video)를 사용해 보세요: ${url}";

  static String m12(current, total) => "동영상 ${current}/${total}";

  static String m13(completed, total) => "동영상 ${completed}/${total}개 압축됨";

  static String m14(size) => "${size} 절약";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("앱 정보"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video)는 작은 불편함에서 시작되었습니다.\n\n이 프로젝트는 모두가 모바일 기기에서 편리하고 무료로 동영상을 압축하여 저장 공간을 절약하고 소중한 순간을 보관할 수 있게 합니다.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("고급"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage("이미 최적화됨"),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "이 동영상은 이미 작습니다. 더 낮은 화질이나 다른 동영상을 사용하세요.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("오디오"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "원본 오디오를 유지하거나 제거하여 공간을 더 절약합니다",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("자동"),
    "better": MessageLookupByLibrary.simpleMessage("더 좋게"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "공간을 절약하도록 비트레이트를 낮춥니다",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage("캐시를 지울 수 없습니다"),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("캐시 지워짐"),
    "cancel": MessageLookupByLibrary.simpleMessage("취소"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("확인"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "아직 확인하지 않은 업데이트 내용",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("캐시 지우기"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "앱의 임시 파일을 제거합니다. 갤러리에 저장된 동영상은 유지됩니다",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("코덱"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264는 모두 호환되며 HEVC는 더 작을 수 있지만 H.264로 대체될 수 있습니다",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("비교"),
    "compress": MessageLookupByLibrary.simpleMessage("압축"),
    "compressed": MessageLookupByLibrary.simpleMessage("압축됨"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("이후"),
    "compressing": MessageLookupByLibrary.simpleMessage("압축 중..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage("압축 취소됨"),
    "compressionComplete": MessageLookupByLibrary.simpleMessage("압축 완료"),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage("압축이 완료됨"),
    "compressionFailed": MessageLookupByLibrary.simpleMessage("압축 실패"),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "이 동영상을 압축할 수 없습니다. 다시 시도하거나 다른 동영상을 선택하세요.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("다크 테마"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "어두운 화면을 사용합니다",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("이메일 복사됨"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "남은 시간 계산 중...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("실패"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage("동영상 파일을 선택하세요"),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "동영상을 저장할 수 없습니다. 다시 시도하세요",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "동영상을 공유할 수 없습니다. 다시 시도하세요",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("프레임 속도"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "출력 초당 프레임을 제한하며 더 낮은 원본 속도는 유지합니다",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("시작하기"),
    "githubRepository": MessageLookupByLibrary.simpleMessage("github 저장소"),
    "good": MessageLookupByLibrary.simpleMessage("좋음"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC를 사용할 수 없어 이 동영상을 H.264로 저장했습니다",
    ),
    "high": MessageLookupByLibrary.simpleMessage("높음"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "압축을 취소하려면 버튼을 길게 누르세요",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "캐시를 지우려면 버튼을 길게 누르세요",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "원본을 삭제하려면 버튼을 길게 누르세요",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo는 동영상의 새 사본을 만들어 더 효율적으로 저장합니다. 비트레이트와 화면 크기를 낮추거나 오디오를 제거할 수 있습니다.\n\n낮은 비트레이트는 눈에 잘 띄지 않는 작은 세부 정보를 줄이고, 낮은 해상도는 프레임당 픽셀 수를 줄입니다. 둘 다 파일 크기를 줄입니다.\n\n원본 동영상은 변경되지 않으며 압축은 기기에서 진행됩니다.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "동영상이 작아지는 방법",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "압축 중에는 minimo를 열어 두세요. 나갔다가 돌아오면 현재 동영상이 다시 시작됩니다",
    ),
    "language": MessageLookupByLibrary.simpleMessage("언어"),
    "languageDescription": MessageLookupByLibrary.simpleMessage("앱 언어를 선택하세요"),
    "leave": MessageLookupByLibrary.simpleMessage("나가기"),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage("저장하지 않고 나가기"),
    "loadingExitMessage": MessageLookupByLibrary.simpleMessage(
      "선택한 동영상을 불러오는 동안 나갈까요?",
    ),
    "loadingExitTitle": MessageLookupByLibrary.simpleMessage(
      "동영상을 아직 불러오는 중입니다",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "클라우드에서 다운로드하거나 큰 파일을 복사하는 데 시간이 더 걸릴 수 있습니다",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("동영상 가져오는 중..."),
    "low": MessageLookupByLibrary.simpleMessage("낮음"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("khlebobul 제작"),
    "medium": MessageLookupByLibrary.simpleMessage("중간"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "일부 갤러리 메타데이터를 복사할 수 없습니다",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("내 다른 앱"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("내 웹사이트"),
    "next": MessageLookupByLibrary.simpleMessage("다음"),
    "noAudio": MessageLookupByLibrary.simpleMessage("오디오 없음"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "다른 모드를 사용해 보세요 — 이 모드는 크기를 줄이지 않습니다",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "하나 이상의 동영상을 선택하세요. minimo는 로컬 파일을 사용하며 원본을 변경하지 않습니다",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage("동영상 선택"),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "화질 프리셋을 선택하거나 해상도와 오디오를 직접 조정하세요",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage("변경할 내용 선택"),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "압축은 기기에서 진행되며 동영상은 어디에도 업로드되지 않습니다. 결과가 마음에 들면 작은 사본을 저장하세요",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "기본적으로 개인 정보 보호",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video)는 오픈 소스입니다. 코드를 확인하고 프로젝트를 팔로우하거나 문의하세요",
    ),
    "original": MessageLookupByLibrary.simpleMessage("원본"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "일부 원본을 삭제할 수 없습니다",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("이전"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "기기가 뜨거워지면 압축이 느려질 수 있습니다",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("파일에서"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("갤러리에서"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage("화면 켜기"),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "동영상 압축 중 화면이 꺼지지 않게 합니다",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("프로젝트 웹사이트"),
    "quality": MessageLookupByLibrary.simpleMessage("화질"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("앱 평가하기"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage("원본 교체"),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "압축된 동영상을 저장한 다음 사진 앱에서 원본 삭제 확인을 요청합니다",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("해상도"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "크기를 줄여 가장 많은 공간을 절약합니다",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "해상도를 hd로 낮춥니다",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "해상도를 sd로 낮춥니다",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("저장"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("새로 저장"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "원본을 유지하고 갤러리에 새 동영상을 저장합니다",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage("원본 옆에 저장"),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "원본을 유지하고 날짜와 메타데이터를 복사합니다",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("저장 방법"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage("동영상을 앨범에 저장"),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("저장됨"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("설정"),
    "share": MessageLookupByLibrary.simpleMessage("공유"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage("공유 또는 저장…"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage("친구와 공유"),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage("과열 경고 표시"),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "기기가 느려질 수 있을 때 압축 중 작은 배너를 표시합니다",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("간단"),
    "skip": MessageLookupByLibrary.simpleMessage("건너뛰기"),
    "small": MessageLookupByLibrary.simpleMessage("작음"),
    "smaller": MessageLookupByLibrary.simpleMessage("더 작게"),
    "stay": MessageLookupByLibrary.simpleMessage("머무르기"),
    "stereo": MessageLookupByLibrary.simpleMessage("스테레오"),
    "system": MessageLookupByLibrary.simpleMessage("시스템"),
    "todo": MessageLookupByLibrary.simpleMessage("공개 예정"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("다시 시도"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "압축한 동영상을 저장하지 않고 나가시겠습니까?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage("동영상이 저장되지 않음"),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("동영상 비트레이트"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "목표 비트레이트를 설정하거나 화질 프리셋에 맡기세요",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "미리보기 사용 불가",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("대기 중"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
