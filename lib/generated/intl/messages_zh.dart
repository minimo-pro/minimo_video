// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(prefix) => "添加 \"${prefix}\" 前缀";

  static String m1(prefix) => "在原文件名前添加 \"${prefix}\"。关闭后保留原文件名";

  static String m2(version) => "${version} 新功能";

  static String m3(count) =>
      "${Intl.plural(count, one: '约剩 1 分钟', other: '约剩 ${count} 分钟')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '保存 1 个视频', other: '保存 ${count} 个视频')}";

  static String m5(album) => "将压缩后的视频保存到 ${album} 相册，而非最近保存";

  static String m6(error) => "视频已保存，但部分原视频无法删除：${error}";

  static String m7(saved, deleted) => "已保存 ${saved} 个视频，删除 ${deleted} 个原视频";

  static String m8(count) =>
      "${Intl.plural(count, one: '已将 1 个视频保存到图库', other: '已将 ${count} 个视频保存到图库')}";

  static String m9(error) => "视频已保存，但存在问题：${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: '约剩 1 秒', other: '约剩 ${count} 秒')}";

  static String m11(url) => "试试 minimo (video)，轻松缩小手机视频：${url}";

  static String m12(current, total) => "第 ${current} 个，共 ${total} 个视频";

  static String m13(completed, total) => "已压缩 ${completed}/${total} 个视频";

  static String m14(size) => "已节省 ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("关于"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) 源于一个简单的困扰。\n\n本项目让每个人都能在移动设备上方便、免费地压缩视频，节省空间并留住重要时刻。",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("高级"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage("已优化"),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "此视频已经很小。请尝试较低质量或其他视频。",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("音频"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "保留原音频，或移除音频以节省更多空间",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("自动"),
    "better": MessageLookupByLibrary.simpleMessage("更好"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "将降低码率以节省空间",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage("无法清除缓存"),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("缓存已清除"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("知道了"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage("你尚未查看的更新内容"),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("清除缓存"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "删除应用临时文件。已保存到图库的视频不受影响",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("编解码器"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 兼容性最好；HEVC 可能更小，但可能回退到 H.264",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("比较"),
    "compress": MessageLookupByLibrary.simpleMessage("压缩"),
    "compressed": MessageLookupByLibrary.simpleMessage("已压缩"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("压缩后"),
    "compressing": MessageLookupByLibrary.simpleMessage("正在压缩..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage("压缩已取消"),
    "compressionComplete": MessageLookupByLibrary.simpleMessage("压缩完成"),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage("压缩已完成"),
    "compressionFailed": MessageLookupByLibrary.simpleMessage("压缩失败"),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "无法压缩此视频。请重试或选择其他视频。",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("深色主题"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage("使用深色外观"),
    "emailCopied": MessageLookupByLibrary.simpleMessage("邮箱已复制"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "正在估算剩余时间...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("失败"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage("请选择视频文件"),
    "failedToSave": MessageLookupByLibrary.simpleMessage("无法保存视频。请重试"),
    "failedToShare": MessageLookupByLibrary.simpleMessage("无法分享视频。请重试"),
    "frameRate": MessageLookupByLibrary.simpleMessage("帧率"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "限制输出帧率；较低的源帧率保持不变",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("开始"),
    "githubRepository": MessageLookupByLibrary.simpleMessage("github 仓库"),
    "good": MessageLookupByLibrary.simpleMessage("较好"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC 不可用，此视频已以 H.264 保存",
    ),
    "high": MessageLookupByLibrary.simpleMessage("高"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage("长按按钮取消压缩"),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage("长按按钮清除缓存"),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage("长按按钮删除原视频"),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "minimo 会创建视频的新副本，并以更高效的方式存储。它可以降低码率、缩小画面，或按需移除音频。\n\n较低码率会减少难以察觉的细小细节。较低分辨率会减少每帧像素。两者都能缩小文件。\n\n原视频保持不变，压缩在设备上完成。",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage("视频如何变小"),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "压缩时请保持 minimo 打开。如果离开，返回时当前视频将重新开始",
    ),
    "language": MessageLookupByLibrary.simpleMessage("语言"),
    "languageDescription": MessageLookupByLibrary.simpleMessage("选择应用语言"),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage("不保存并离开"),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "从云存储下载或复制大文件可能需要更长时间",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage("正在导入视频..."),
    "low": MessageLookupByLibrary.simpleMessage("低"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("khlebobul 制作"),
    "medium": MessageLookupByLibrary.simpleMessage("中"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "部分图库元数据无法复制",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("我的其他应用"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("我的网站"),
    "next": MessageLookupByLibrary.simpleMessage("下一步"),
    "noAudio": MessageLookupByLibrary.simpleMessage("无音频"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "请尝试其他模式 — 此模式不会缩小文件",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "选择一个或多个视频。minimo 处理本地文件，不会修改原视频",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage("选择视频"),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "选择质量预设，或手动调整分辨率和音频",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage("选择要更改的内容"),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "压缩在设备上完成，视频不会上传。对结果满意后保存较小的副本",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage("默认保护隐私"),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) 是开源项目。查看代码、关注项目或与我联系",
    ),
    "original": MessageLookupByLibrary.simpleMessage("原始"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage("部分原视频无法删除"),
    "originalVideo": MessageLookupByLibrary.simpleMessage("压缩前"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage("设备发热时，压缩可能变慢"),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("从文件选择"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("从图库选择"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage("保持屏幕亮起"),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "压缩视频时防止屏幕休眠",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("项目网站"),
    "quality": MessageLookupByLibrary.simpleMessage("质量"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("为应用评分"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage("替换原视频"),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "压缩后的视频将先保存，然后图库会要求确认删除原视频",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("分辨率"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "降低尺寸可最大幅度节省空间",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "分辨率将降低到 hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "分辨率将降低到 sd",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("保存为新视频"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "保留原视频，并在图库中保存新视频",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage("保存在原视频旁"),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "保留原视频，并复制其日期和元数据",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("保存方式"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage("将视频保存到相册"),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("已保存"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "share": MessageLookupByLibrary.simpleMessage("分享"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage("分享或保存到…"),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage("分享给朋友"),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage("显示过热警告"),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "设备可能因发热变慢时，在压缩期间显示小提示",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("简单"),
    "skip": MessageLookupByLibrary.simpleMessage("跳过"),
    "small": MessageLookupByLibrary.simpleMessage("小"),
    "smaller": MessageLookupByLibrary.simpleMessage("更小"),
    "stay": MessageLookupByLibrary.simpleMessage("留下"),
    "stereo": MessageLookupByLibrary.simpleMessage("立体声"),
    "system": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "todo": MessageLookupByLibrary.simpleMessage("即将推出"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("重试"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "不保存压缩视频就离开？",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage("视频未保存"),
    "videoBitrate": MessageLookupByLibrary.simpleMessage("视频码率"),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "设置目标码率，或由质量预设选择",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage("预览不可用"),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("等待中"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
