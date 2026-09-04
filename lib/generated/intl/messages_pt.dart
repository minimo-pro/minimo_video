// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
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
  String get localeName => 'pt';

  static String m0(prefix) => "adicionar o prefixo \"${prefix}\"";

  static String m1(prefix) =>
      "adiciona \"${prefix}\" antes do nome original. ao desativar, mantém o nome original";

  static String m2(version) => "novidades da versão ${version}";

  static String m3(count) =>
      "${Intl.plural(count, one: 'falta cerca de 1 minuto', other: 'faltam cerca de ${count} minutos')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'salvar 1 vídeo', other: 'salvar ${count} vídeos')}";

  static String m5(album) =>
      "salva os vídeos comprimidos no álbum ${album} em vez dos itens recentes";

  static String m6(error) =>
      "os vídeos foram salvos, mas alguns originais não puderam ser excluídos: ${error}";

  static String m7(saved, deleted) =>
      "vídeos salvos: ${saved}; originais excluídos: ${deleted}";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 vídeo salvo na galeria', other: '${count} vídeos salvos na galeria')}";

  static String m9(error) =>
      "os vídeos foram salvos com alguns problemas: ${error}";

  static String m10(count) =>
      "${Intl.plural(count, one: 'falta cerca de 1 segundo', other: 'faltam cerca de ${count} segundos')}";

  static String m11(url) =>
      "experimente minimo (video), um app simples para diminuir vídeos no celular: ${url}";

  static String m12(current, total) => "vídeo ${current} de ${total}";

  static String m13(completed, total) =>
      "${completed} de ${total} vídeos comprimidos";

  static String m14(size) => "você economizou ${size}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("sobre"),
    "aboutStory": MessageLookupByLibrary.simpleMessage(
      "minimo (video) nasceu de uma frustração simples.\n\neste projeto oferece a todos uma maneira prática e gratuita de comprimir vídeos diretamente no celular, economizar espaço e guardar os momentos importantes.",
    ),
    "addPrefix": m0,
    "addPrefixDescription": m1,
    "advancedOptions": MessageLookupByLibrary.simpleMessage("avançado"),
    "alreadyOptimized": MessageLookupByLibrary.simpleMessage("já otimizado"),
    "alreadyOptimizedDescription": MessageLookupByLibrary.simpleMessage(
      "este vídeo já é pequeno. tente uma qualidade menor ou escolha outro.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("minimo (video)"),
    "audio": MessageLookupByLibrary.simpleMessage("áudio"),
    "audioDescription": MessageLookupByLibrary.simpleMessage(
      "mantenha o áudio original ou remova-o para economizar mais espaço",
    ),
    "automatic": MessageLookupByLibrary.simpleMessage("auto"),
    "better": MessageLookupByLibrary.simpleMessage("melhor"),
    "bitrateReducedDescription": MessageLookupByLibrary.simpleMessage(
      "a taxa de bits será reduzida para economizar espaço",
    ),
    "cacheClearFailed": MessageLookupByLibrary.simpleMessage(
      "não foi possível limpar o cache",
    ),
    "cacheCleared": MessageLookupByLibrary.simpleMessage("cache limpo"),
    "cancel": MessageLookupByLibrary.simpleMessage("cancelar"),
    "changelogDone": MessageLookupByLibrary.simpleMessage("entendi"),
    "changelogSubtitle": MessageLookupByLibrary.simpleMessage(
      "mudanças de atualizações que você ainda não viu",
    ),
    "changelogTitle": m2,
    "clearCache": MessageLookupByLibrary.simpleMessage("limpar cache"),
    "clearCacheDescription": MessageLookupByLibrary.simpleMessage(
      "remove arquivos temporários do app. os vídeos salvos na galeria permanecem intactos",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("codec"),
    "codecDescription": MessageLookupByLibrary.simpleMessage(
      "H.264 funciona em todo lugar; HEVC pode ser menor, mas pode voltar para H.264",
    ),
    "compareVideos": MessageLookupByLibrary.simpleMessage("comparar"),
    "compress": MessageLookupByLibrary.simpleMessage("comprimir"),
    "compressed": MessageLookupByLibrary.simpleMessage("comprimido"),
    "compressedVideo": MessageLookupByLibrary.simpleMessage("depois"),
    "compressing": MessageLookupByLibrary.simpleMessage("comprimindo..."),
    "compressionCancelled": MessageLookupByLibrary.simpleMessage(
      "compressão cancelada",
    ),
    "compressionComplete": MessageLookupByLibrary.simpleMessage(
      "compressão concluída",
    ),
    "compressionCompleted": MessageLookupByLibrary.simpleMessage(
      "compressão concluída",
    ),
    "compressionFailed": MessageLookupByLibrary.simpleMessage(
      "falha na compressão",
    ),
    "compressionFailedDescription": MessageLookupByLibrary.simpleMessage(
      "não foi possível comprimir este vídeo. tente novamente ou escolha outro.",
    ),
    "darkTheme": MessageLookupByLibrary.simpleMessage("tema escuro"),
    "darkThemeDescription": MessageLookupByLibrary.simpleMessage(
      "usar aparência escura",
    ),
    "emailCopied": MessageLookupByLibrary.simpleMessage("e-mail copiado"),
    "english": MessageLookupByLibrary.simpleMessage("english"),
    "estimatingTimeRemaining": MessageLookupByLibrary.simpleMessage(
      "calculando o tempo restante...",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("falhou"),
    "failedToPickVideos": MessageLookupByLibrary.simpleMessage(
      "escolha um arquivo de vídeo",
    ),
    "failedToSave": MessageLookupByLibrary.simpleMessage(
      "não foi possível salvar os vídeos. tente novamente",
    ),
    "failedToShare": MessageLookupByLibrary.simpleMessage(
      "não foi possível compartilhar os vídeos. tente novamente",
    ),
    "frameRate": MessageLookupByLibrary.simpleMessage("taxa de quadros"),
    "frameRateDescription": MessageLookupByLibrary.simpleMessage(
      "limita os quadros por segundo na saída; taxas menores da origem não são aumentadas",
    ),
    "getStarted": MessageLookupByLibrary.simpleMessage("começar"),
    "githubRepository": MessageLookupByLibrary.simpleMessage(
      "repositório no github",
    ),
    "good": MessageLookupByLibrary.simpleMessage("boa"),
    "hevcFallbackNotice": MessageLookupByLibrary.simpleMessage(
      "HEVC não estava disponível, então o vídeo foi salvo como H.264",
    ),
    "high": MessageLookupByLibrary.simpleMessage("alta"),
    "holdToCancelCompression": MessageLookupByLibrary.simpleMessage(
      "mantenha o botão pressionado para cancelar a compressão",
    ),
    "holdToClearCache": MessageLookupByLibrary.simpleMessage(
      "mantenha o botão pressionado para limpar o cache",
    ),
    "holdToDeleteOriginals": MessageLookupByLibrary.simpleMessage(
      "mantenha o botão pressionado para excluir os originais",
    ),
    "howCompressionWorksBody": MessageLookupByLibrary.simpleMessage(
      "o minimo cria uma nova cópia do seu vídeo e a armazena de forma mais eficiente. ele pode reduzir a taxa de bits, diminuir a resolução ou remover o áudio se você escolher.\n\numa taxa de bits menor preserva menos pequenos detalhes difíceis de perceber. uma resolução menor significa menos pixels em cada quadro. ambos reduzem o tamanho do arquivo.\n\no vídeo original fica intacto e a compressão acontece no seu dispositivo.",
    ),
    "howCompressionWorksTitle": MessageLookupByLibrary.simpleMessage(
      "como o vídeo fica menor",
    ),
    "iosBackgroundCompressionWarning": MessageLookupByLibrary.simpleMessage(
      "mantenha o minimo aberto durante a compressão. se sair, o vídeo atual reiniciará quando você voltar",
    ),
    "language": MessageLookupByLibrary.simpleMessage("idioma"),
    "languageDescription": MessageLookupByLibrary.simpleMessage(
      "escolha o idioma do app",
    ),
    "leave": MessageLookupByLibrary.simpleMessage("sair"),
    "leaveWithoutSaving": MessageLookupByLibrary.simpleMessage(
      "sair sem salvar",
    ),
    "loadingExitMessage": MessageLookupByLibrary.simpleMessage(
      "sair enquanto os vídeos selecionados ainda estão carregando?",
    ),
    "loadingExitTitle": MessageLookupByLibrary.simpleMessage(
      "os vídeos ainda estão carregando",
    ),
    "loadingManyVideosHint": MessageLookupByLibrary.simpleMessage(
      "baixar da nuvem ou copiar arquivos grandes pode demorar mais",
    ),
    "loadingVideos": MessageLookupByLibrary.simpleMessage(
      "importando vídeos...",
    ),
    "low": MessageLookupByLibrary.simpleMessage("baixa"),
    "madeByKhlebobul": MessageLookupByLibrary.simpleMessage("por khlebobul"),
    "medium": MessageLookupByLibrary.simpleMessage("média"),
    "metadataPreservationIncomplete": MessageLookupByLibrary.simpleMessage(
      "alguns metadados da galeria não puderam ser copiados",
    ),
    "minutesRemaining": m3,
    "myOtherApps": MessageLookupByLibrary.simpleMessage("meus outros apps"),
    "myWebsite": MessageLookupByLibrary.simpleMessage("meu site"),
    "next": MessageLookupByLibrary.simpleMessage("próximo"),
    "noAudio": MessageLookupByLibrary.simpleMessage("sem áudio"),
    "noSavingsHint": MessageLookupByLibrary.simpleMessage(
      "tente outro modo — este não vai diminuir o tamanho",
    ),
    "onboardingPickDescription": MessageLookupByLibrary.simpleMessage(
      "escolha um ou vários vídeos. o minimo trabalha com arquivos locais e mantém os originais intactos",
    ),
    "onboardingPickTitle": MessageLookupByLibrary.simpleMessage(
      "escolha vídeos",
    ),
    "onboardingQualityDescription": MessageLookupByLibrary.simpleMessage(
      "escolha uma predefinição de qualidade ou ajuste manualmente a resolução e o áudio",
    ),
    "onboardingQualityTitle": MessageLookupByLibrary.simpleMessage(
      "escolha o que mudar",
    ),
    "onboardingSaveDescription": MessageLookupByLibrary.simpleMessage(
      "a compressão acontece no seu dispositivo. os vídeos não são enviados para nenhum lugar; salve a cópia menor quando gostar do resultado",
    ),
    "onboardingSaveTitle": MessageLookupByLibrary.simpleMessage(
      "privado por padrão",
    ),
    "openSourceNote": MessageLookupByLibrary.simpleMessage(
      "minimo (video) tem código aberto. explore o código, acompanhe o projeto ou entre em contato",
    ),
    "original": MessageLookupByLibrary.simpleMessage("original"),
    "originalDeletionFailed": MessageLookupByLibrary.simpleMessage(
      "alguns originais não puderam ser excluídos",
    ),
    "originalVideo": MessageLookupByLibrary.simpleMessage("antes"),
    "overheatWarning": MessageLookupByLibrary.simpleMessage(
      "a compressão pode ficar mais lenta se o dispositivo esquentar",
    ),
    "pickFromFiles": MessageLookupByLibrary.simpleMessage("dos arquivos"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage("da galeria"),
    "preventScreenSleep": MessageLookupByLibrary.simpleMessage(
      "manter a tela ligada",
    ),
    "preventScreenSleepDescription": MessageLookupByLibrary.simpleMessage(
      "impede que a tela desligue enquanto os vídeos são comprimidos",
    ),
    "projectWebsite": MessageLookupByLibrary.simpleMessage("site do projeto"),
    "quality": MessageLookupByLibrary.simpleMessage("qualidade"),
    "rateTheApp": MessageLookupByLibrary.simpleMessage("avaliar o app"),
    "replaceOriginal": MessageLookupByLibrary.simpleMessage(
      "substituir o original",
    ),
    "replaceOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "o vídeo comprimido será salvo; depois, o Fotos pedirá para confirmar a exclusão do original",
    ),
    "resolution": MessageLookupByLibrary.simpleMessage("resolução"),
    "resolutionDescription": MessageLookupByLibrary.simpleMessage(
      "reduza as dimensões para economizar o máximo de espaço",
    ),
    "resolutionReducedHdDescription": MessageLookupByLibrary.simpleMessage(
      "a resolução será reduzida para hd",
    ),
    "resolutionReducedSdDescription": MessageLookupByLibrary.simpleMessage(
      "a resolução será reduzida para sd",
    ),
    "russian": MessageLookupByLibrary.simpleMessage("русский"),
    "save": MessageLookupByLibrary.simpleMessage("salvar"),
    "saveAsNew": MessageLookupByLibrary.simpleMessage("salvar como novo"),
    "saveAsNewDescription": MessageLookupByLibrary.simpleMessage(
      "manter o original e salvar um novo vídeo na galeria",
    ),
    "saveBesideOriginal": MessageLookupByLibrary.simpleMessage(
      "salvar ao lado do original",
    ),
    "saveBesideOriginalDescription": MessageLookupByLibrary.simpleMessage(
      "manter o original e copiar a data e os metadados dele",
    ),
    "saveOptionsTitle": MessageLookupByLibrary.simpleMessage("como salvar"),
    "saveVideos": m4,
    "saveVideosToAlbum": MessageLookupByLibrary.simpleMessage(
      "salvar vídeos em um álbum",
    ),
    "saveVideosToAlbumDescription": m5,
    "saved": MessageLookupByLibrary.simpleMessage("salvo"),
    "savedButOriginalsNotDeleted": m6,
    "savedVideosAndDeletedOriginals": m7,
    "savedVideosToGallery": m8,
    "savedWithWarnings": m9,
    "secondsRemaining": m10,
    "settings": MessageLookupByLibrary.simpleMessage("configurações"),
    "share": MessageLookupByLibrary.simpleMessage("compartilhar"),
    "shareAppText": m11,
    "shareOrSave": MessageLookupByLibrary.simpleMessage(
      "compartilhar ou salvar em…",
    ),
    "shareWithFriends": MessageLookupByLibrary.simpleMessage(
      "compartilhar com amigos",
    ),
    "showOverheatWarning": MessageLookupByLibrary.simpleMessage(
      "mostrar aviso de superaquecimento",
    ),
    "showOverheatWarningDescription": MessageLookupByLibrary.simpleMessage(
      "mostra um pequeno aviso durante a compressão quando o dispositivo pode ficar mais lento",
    ),
    "simpleOptions": MessageLookupByLibrary.simpleMessage("simples"),
    "skip": MessageLookupByLibrary.simpleMessage("pular"),
    "small": MessageLookupByLibrary.simpleMessage("pequeno"),
    "smaller": MessageLookupByLibrary.simpleMessage("menor"),
    "stay": MessageLookupByLibrary.simpleMessage("ficar"),
    "stereo": MessageLookupByLibrary.simpleMessage("estéreo"),
    "system": MessageLookupByLibrary.simpleMessage("sistema"),
    "todo": MessageLookupByLibrary.simpleMessage("EM BREVE"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("tentar novamente"),
    "unsavedResultsMessage": MessageLookupByLibrary.simpleMessage(
      "sair sem salvar os vídeos comprimidos?",
    ),
    "unsavedResultsTitle": MessageLookupByLibrary.simpleMessage(
      "vídeos não salvos",
    ),
    "videoBitrate": MessageLookupByLibrary.simpleMessage(
      "taxa de bits do vídeo",
    ),
    "videoBitrateDescription": MessageLookupByLibrary.simpleMessage(
      "defina uma taxa de bits desejada ou deixe a qualidade escolhê-la",
    ),
    "videoPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "prévia indisponível",
    ),
    "videoProgress": m12,
    "videosCompressed": m13,
    "waiting": MessageLookupByLibrary.simpleMessage("aguardando"),
    "xTwitter": MessageLookupByLibrary.simpleMessage("x (twitter)"),
    "youSavedSize": m14,
  };
}
