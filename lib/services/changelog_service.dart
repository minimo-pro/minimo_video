import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_launch_service.dart';

enum Language {
  en('en'),
  ru('ru'),
  es('es'),
  pt('pt'),
  de('de'),
  fr('fr'),
  zh('zh'),
  hi('hi'),
  nl('nl'),
  ko('ko'),
  ja('ja'),
  it('it'),
  tr('tr');

  final String code;

  const Language(this.code);

  static Language fromCode(String? code) => switch (code) {
    'ru' => Language.ru,
    'es' => Language.es,
    'pt' => Language.pt,
    'de' => Language.de,
    'fr' => Language.fr,
    'zh' => Language.zh,
    'hi' => Language.hi,
    'nl' => Language.nl,
    'ko' => Language.ko,
    'ja' => Language.ja,
    'it' => Language.it,
    'tr' => Language.tr,
    _ => Language.en,
  };
}

typedef Changelog = Map<String, Map<Language, List<String>>>;

const Changelog _changelog = {
  '1.3.1': {
    Language.en: ['fixed importing videos with long filenames.'],
    Language.ru: ['исправлен импорт видео с длинными именами файлов.'],
    Language.es: [
      'se corrigió la importación de videos con nombres de archivo largos.',
    ],
    Language.pt: [
      'corrigimos a importação de vídeos com nomes de arquivo longos.',
    ],
    Language.de: [
      'der import von videos mit langen dateinamen wurde korrigiert.',
    ],
    Language.fr: [
      'correction de l’importation des vidéos dont le nom de fichier est long.',
    ],
    Language.zh: ['修复了无法导入文件名过长的视频的问题。'],
    Language.hi: [
      'लंबे फ़ाइल नाम वाले वीडियो इंपोर्ट करने की समस्या ठीक की गई।',
    ],
    Language.nl: [
      'een probleem met het importeren van video’s met lange bestandsnamen is opgelost.',
    ],
    Language.ko: ['파일 이름이 긴 동영상을 가져오지 못하던 문제를 해결했습니다.'],
    Language.ja: ['ファイル名が長い動画を読み込めない問題を修正しました。'],
    Language.it: [
      'risolto un problema con l’importazione di video con nomi di file lunghi.',
    ],
    Language.tr: [
      'uzun dosya adlarına sahip videoları içe aktarma sorunu giderildi.',
    ],
  },
  '1.3.0': {
    Language.en: [
      'compression now preserves HDR where supported.',
    ],
    Language.ru: [
      'при сжатии теперь сохраняется HDR, если это поддерживается.',
    ],
    Language.es: [
      'la compresión ahora conserva el HDR cuando es compatible.',
    ],
    Language.pt: [
      'a compressão agora preserva o HDR quando há suporte.',
    ],
    Language.de: [
      'bei der komprimierung bleibt HDR jetzt erhalten, sofern unterstützt.',
    ],
    Language.fr: [
      'la compression préserve désormais le HDR lorsque celui-ci est pris en charge.',
    ],
    Language.zh: ['在支持的情况下，压缩视频时可保留 HDR。'],
    Language.hi: [
      'जहाँ सुविधा उपलब्ध है, वीडियो कंप्रेस करते समय HDR अब बरकरार रहता है।',
    ],
    Language.nl: [
      'bij het comprimeren blijft HDR nu behouden waar dit wordt ondersteund.',
    ],
    Language.ko: ['지원되는 경우 동영상 압축 시 HDR이 유지됩니다.'],
    Language.ja: ['対応している場合は、動画の圧縮時に HDR を保持できます。'],
    Language.it: [
      'la compressione ora mantiene l’HDR dove supportato.',
    ],
    Language.tr: [
      'desteklendiğinde video sıkıştırma sırasında HDR artık korunuyor.',
    ],
  },
  '1.2.0': {
    Language.en: [
      'on supported devices, videos selected from the gallery or files can continue importing in the background with system progress and cancellation.',
      'refreshed onboarding with animated video cards and clearer step progress.',
    ],
    Language.ru: [
      'на поддерживаемых устройствах импорт видео из галереи и файлов может продолжаться в фоне с системным индикатором прогресса и возможностью отмены.',
      'обновлённый онбординг с анимированными карточками видео и наглядным прогрессом шагов.',
    ],
    Language.es: [
      'en dispositivos compatibles, la importación de videos seleccionados de la galería o archivos puede continuar en segundo plano con progreso del sistema y opción de cancelar.',
      'bienvenida renovada con tarjetas de video animadas y un progreso de pasos más claro.',
    ],
    Language.pt: [
      'em dispositivos compatíveis, a importação de vídeos selecionados da galeria ou de arquivos pode continuar em segundo plano com progresso do sistema e opção de cancelar.',
      'introdução renovada com cartões de vídeo animados e progresso das etapas mais claro.',
    ],
    Language.de: [
      'auf unterstützten geräten kann der import von videos aus der galerie oder aus dateien im hintergrund fortgesetzt werden, mit systemweiter fortschrittsanzeige und abbruchmöglichkeit.',
      'überarbeitete einführung mit animierten videokarten und klarer fortschrittsanzeige.',
    ],
    Language.fr: [
      'sur les appareils compatibles, l’importation des vidéos sélectionnées dans la galerie ou les fichiers peut continuer en arrière-plan avec un indicateur de progression système et une option d’annulation.',
      'présentation repensée avec des cartes vidéo animées et une progression plus claire.',
    ],
    Language.zh: [
      '在支持的设备上，从图库或文件中选择的视频可在后台继续导入，并提供系统进度显示和取消选项。',
      '全新引导流程，配有动态视频卡片和更清晰的步骤进度。',
    ],
    Language.hi: [
      'समर्थित डिवाइस पर गैलरी या फ़ाइलों से चुने गए वीडियो का इंपोर्ट बैकग्राउंड में जारी रह सकता है। सिस्टम में प्रगति दिखाई देती है और इसे रद्द किया जा सकता है।',
      'एनिमेटेड वीडियो कार्ड और स्पष्ट चरण प्रगति के साथ नया परिचय।',
    ],
    Language.nl: [
      'op ondersteunde apparaten kan het importeren van video’s uit de galerij of bestanden op de achtergrond doorgaan, met systeemvoortgang en een optie om te annuleren.',
      'vernieuwde introductie met geanimeerde videokaarten en duidelijkere voortgang per stap.',
    ],
    Language.ko: [
      '지원되는 기기에서는 갤러리나 파일에서 선택한 동영상을 백그라운드에서도 계속 가져올 수 있으며 시스템 진행 표시와 취소 기능을 제공합니다.',
      '애니메이션 동영상 카드와 더 명확한 단계 표시로 시작 안내를 새롭게 꾸몄습니다.',
    ],
    Language.ja: [
      '対応するデバイスでは、ギャラリーやファイルから選んだ動画の読み込みをバックグラウンドでも続けられます。システムの進捗表示とキャンセル機能も利用できます。',
      '動画カードのアニメーションと分かりやすい進行表示で、初回ガイドを刷新しました。',
    ],
    Language.it: [
      'sui dispositivi compatibili, l’importazione dei video selezionati dalla galleria o dai file può continuare in background con avanzamento di sistema e possibilità di annullamento.',
      'introduzione rinnovata con schede video animate e avanzamento dei passaggi più chiaro.',
    ],
    Language.tr: [
      'desteklenen cihazlarda galeriden veya dosyalardan seçilen videoları içe aktarma işlemi, sistem ilerleme göstergesi ve iptal seçeneğiyle arka planda devam edebilir.',
      'animasyonlu video kartları ve daha net adım ilerlemesiyle yenilenen başlangıç rehberi.',
    ],
  },
  '1.1.1': {
    Language.en: [
      'share your compressed video count and saved space from the statistics screen.',
    ],
    Language.ru: [
      'делитесь количеством сжатых видео и освобождённым местом с экрана статистики.',
    ],
    Language.es: [
      'comparta la cantidad de videos comprimidos y el espacio ahorrado desde la pantalla de estadísticas.',
    ],
    Language.pt: [
      'compartilhe a quantidade de vídeos comprimidos e o espaço economizado pela tela de estatísticas.',
    ],
    Language.de: [
      'teilen sie die anzahl komprimierter videos und den gesparten speicherplatz über die statistikansicht.',
    ],
    Language.fr: [
      'partagez le nombre de vidéos compressées et l’espace économisé depuis l’écran des statistiques.',
    ],
    Language.zh: ['在统计页面分享已压缩的视频数量和节省的空间。'],
    Language.hi: [
      'आँकड़ों की स्क्रीन से कंप्रेस किए गए वीडियो की संख्या और बचाई गई जगह शेयर करें।',
    ],
    Language.nl: [
      'deel het aantal gecomprimeerde video’s en de bespaarde ruimte vanuit het statistiekenscherm.',
    ],
    Language.ko: ['통계 화면에서 압축한 동영상 수와 절약한 공간을 공유하세요.'],
    Language.ja: ['統計画面から、圧縮した動画の本数と節約した容量を共有できます。'],
    Language.it: [
      'condivida il numero di video compressi e lo spazio risparmiato dalla schermata delle statistiche.',
    ],
    Language.tr: [
      'istatistik ekranından sıkıştırılan video sayısını ve kazanılan alanı paylaşın.',
    ],
  },
  '1.1.0': {
    Language.en: [
      'on supported devices, video compression can continue in the background with system progress and cancellation.',
    ],
    Language.ru: [
      'на поддерживаемых устройствах сжатие видео может продолжаться в фоне с системным индикатором прогресса и возможностью отмены.',
    ],
    Language.es: [
      'en dispositivos compatibles, la compresión de videos puede continuar en segundo plano con progreso del sistema y opción de cancelar.',
    ],
    Language.pt: [
      'em dispositivos compatíveis, a compressão de vídeos pode continuar em segundo plano com progresso do sistema e opção de cancelar.',
    ],
    Language.de: [
      'auf unterstützten geräten kann die videokomprimierung im hintergrund fortgesetzt werden, mit systemweiter fortschrittsanzeige und abbruchmöglichkeit.',
    ],
    Language.fr: [
      'sur les appareils compatibles, la compression vidéo peut continuer en arrière-plan avec un indicateur de progression système et une option d’annulation.',
    ],
    Language.zh: ['在支持的设备上，视频压缩可在后台继续，并提供系统进度显示和取消选项。'],
    Language.hi: [
      'समर्थित डिवाइस पर वीडियो कंप्रेशन बैकग्राउंड में जारी रह सकता है। सिस्टम में प्रगति दिखाई देती है और इसे रद्द किया जा सकता है।',
    ],
    Language.nl: [
      'op ondersteunde apparaten kan videocompressie op de achtergrond doorgaan, met systeemvoortgang en een optie om te annuleren.',
    ],
    Language.ko: [
      '지원되는 기기에서는 시스템 진행 표시와 취소 기능을 통해 백그라운드에서도 동영상 압축을 계속할 수 있습니다.',
    ],
    Language.ja: ['対応するデバイスでは、システムの進捗表示とキャンセル機能を使い、バックグラウンドでも動画の圧縮を続けられます。'],
    Language.it: [
      'sui dispositivi compatibili, la compressione video può continuare in background con avanzamento di sistema e possibilità di annullamento.',
    ],
    Language.tr: [
      'desteklenen cihazlarda video sıkıştırma, sistem ilerleme göstergesi ve iptal seçeneğiyle arka planda devam edebilir.',
    ],
  },
  '1.0.16': {
    Language.en: [
      'secondary text is easier to read in the light theme.',
      'the save button shows a loading indicator while videos are being saved.',
    ],
    Language.ru: [
      'второстепенный текст в светлой теме стал контрастнее и легче читается.',
      'пока видео сохраняются, на кнопке сохранения показывается индикатор загрузки.',
    ],
    Language.es: [
      'el texto secundario es más fácil de leer en el tema claro.',
      'el botón de guardar muestra un indicador de carga mientras se guardan los videos.',
    ],
    Language.pt: [
      'o texto secundário ficou mais fácil de ler no tema claro.',
      'o botão de salvar mostra um indicador de carregamento enquanto os vídeos são salvos.',
    ],
    Language.de: [
      'sekundärer text ist im hellen design besser lesbar.',
      'die sichern-schaltfläche zeigt einen ladehinweis, während videos gespeichert werden.',
    ],
    Language.fr: [
      'le texte secondaire est plus lisible dans le thème clair.',
      'le bouton d’enregistrement affiche un indicateur de chargement pendant l’enregistrement des vidéos.',
    ],
    Language.zh: ['浅色主题中的次要文字更容易阅读。', '保存视频时，保存按钮会显示加载指示。'],
    Language.hi: [
      'हल्की थीम में सहायक टेक्स्ट अब पढ़ने में आसान है।',
      'वीडियो सेव होते समय सेव बटन पर लोडिंग संकेत दिखता है।',
    ],
    Language.nl: [
      'secundaire tekst is beter leesbaar in het lichte thema.',
      'de opslaan-knop toont een laadindicator terwijl video’s worden opgeslagen.',
    ],
    Language.ko: [
      '라이트 테마의 보조 텍스트가 더 읽기 쉬워졌습니다.',
      '동영상을 저장하는 동안 저장 버튼에 로딩 표시가 나타납니다.',
    ],
    Language.ja: ['ライトテーマの補助テキストが読みやすくなりました。', '動画の保存中は、保存ボタンに読み込み表示が出ます。'],
    Language.it: [
      'il testo secondario è più leggibile nel tema chiaro.',
      'il pulsante di salvataggio mostra un indicatore di caricamento mentre i video vengono salvati.',
    ],
    Language.tr: [
      'açık temadaki ikincil metin artık daha kolay okunuyor.',
      'videolar kaydedilirken kaydet düğmesinde bir yükleme göstergesi görünür.',
    ],
  },
  '1.0.15': {
    Language.en: [
      'hdr videos are now saved as sdr for wider playback compatibility; colors may change.',
      'hdr videos now show a badge and a conversion note before compression.',
      'video counts now stay on one line in the selection badge.',
    ],
    Language.ru: [
      'hdr-видео теперь сохраняются в sdr для совместимости с большим числом плееров; цвета могут измениться.',
      'перед сжатием hdr-видео показываются метка и предупреждение о преобразовании.',
      'количество выбранных видео теперь помещается в метке в одну строку.',
    ],
    Language.es: [
      'los videos hdr ahora se guardan en sdr para mejorar la compatibilidad de reproducción; los colores pueden cambiar.',
      'antes de comprimir videos hdr, se muestran una etiqueta y un aviso de conversión.',
      'la cantidad de videos seleccionados ahora cabe en una línea en la etiqueta.',
    ],
    Language.pt: [
      'os vídeos hdr agora são salvos em sdr para maior compatibilidade de reprodução; as cores podem mudar.',
      'antes da compressão, os vídeos hdr mostram um selo e um aviso de conversão.',
      'a quantidade de vídeos selecionados agora cabe em uma linha no selo.',
    ],
    Language.de: [
      'hdr-videos werden jetzt als sdr gespeichert und sind mit mehr playern kompatibel; farben können sich ändern.',
      'vor dem komprimieren zeigen hdr-videos eine markierung und einen hinweis zur umwandlung.',
      'die anzahl ausgewählter videos bleibt in der markierung jetzt einzeilig.',
    ],
    Language.fr: [
      'les vidéos hdr sont désormais enregistrées en sdr pour une meilleure compatibilité de lecture ; les couleurs peuvent changer.',
      'avant la compression, les vidéos hdr affichent un badge et un avis de conversion.',
      'le nombre de vidéos sélectionnées tient désormais sur une seule ligne dans le badge.',
    ],
    Language.zh: [
      'hdr 视频现在保存为 sdr，以兼容更多播放器；颜色可能会发生变化。',
      '压缩前，hdr 视频会显示标记和转换提示。',
      '已选视频数量现在会在标记中保持单行显示。',
    ],
    Language.hi: [
      'hdr वीडियो अब sdr में सेव होते हैं ताकि ज़्यादा प्लेयर में चल सकें; रंग बदल सकते हैं।',
      'कंप्रेस करने से पहले hdr वीडियो पर बैज और बदलाव की सूचना दिखाई देती है।',
      'चुने गए वीडियो की संख्या अब बैज में एक ही पंक्ति में रहती है।',
    ],
    Language.nl: [
      'hdr-video’s worden nu als sdr opgeslagen voor betere afspeelcompatibiliteit; kleuren kunnen veranderen.',
      'vóór het comprimeren tonen hdr-video’s een badge en een melding over de omzetting.',
      'het aantal geselecteerde video’s blijft nu op één regel in de badge.',
    ],
    Language.ko: [
      'hdr 동영상은 이제 더 많은 플레이어에서 재생할 수 있도록 sdr로 저장됩니다. 색상이 달라질 수 있습니다.',
      '압축 전에 hdr 동영상에 배지와 변환 안내가 표시됩니다.',
      '선택한 동영상 수가 이제 배지 안에서 한 줄로 표시됩니다.',
    ],
    Language.ja: [
      'hdr 動画をより多くのプレーヤーで再生できるよう、sdr で保存します。色が変わる場合があります。',
      '圧縮前に hdr 動画のバッジと変換に関する案内を表示します。',
      '選択した動画の数がバッジ内で一行に収まるようになりました。',
    ],
    Language.it: [
      'i video hdr ora vengono salvati in sdr per una maggiore compatibilità di riproduzione; i colori possono cambiare.',
      'prima della compressione, i video hdr mostrano un badge e un avviso sulla conversione.',
      'il numero di video selezionati ora resta su una sola riga nel badge.',
    ],
    Language.tr: [
      'hdr videolar, daha fazla oynatıcıyla uyum için artık sdr olarak kaydediliyor; renkler değişebilir.',
      'sıkıştırmadan önce hdr videolarda bir rozet ve dönüştürme uyarısı gösterilir.',
      'seçilen video sayısı artık rozette tek satırda kalır.',
    ],
  },
  '1.0.14': {
    Language.en: ['added a link to minimo (photo) in settings and about.'],
    Language.ru: [
      'добавлена ссылка на minimo (photo) в разделе «о приложении».',
      'добавлена ссылка на minimo (photo) в настройки.',
    ],
    Language.es: [
      'se añadió un enlace a minimo (photo) en la pantalla acerca de.',
      'se añadió un enlace a minimo (photo) en ajustes.',
    ],
    Language.pt: [
      'foi adicionado um link para minimo (photo) na tela sobre.',
      'foi adicionado um link para minimo (photo) nas configurações.',
    ],
    Language.de: [
      'ein link zu minimo (photo) wurde dem bildschirm „über“ hinzugefügt.',
      'ein link zu minimo (photo) wurde den einstellungen hinzugefügt.',
    ],
    Language.fr: [
      'un lien vers minimo (photo) a été ajouté à la page à propos.',
      'un lien vers minimo (photo) a été ajouté aux réglages.',
    ],
    Language.zh: [
      '在“关于”页面添加了 minimo (photo) 链接。',
      '在设置中添加了 minimo (photo) 链接。',
    ],
    Language.hi: [
      'परिचय स्क्रीन पर minimo (photo) का लिंक जोड़ा गया।',
      'सेटिंग्स में minimo (photo) का लिंक जोड़ा गया।',
    ],
    Language.nl: [
      'een link naar minimo (photo) toegevoegd aan het scherm over.',
      'een link naar minimo (photo) toegevoegd aan instellingen.',
    ],
    Language.ko: [
      '정보 화면에 minimo (photo) 링크를 추가했습니다.',
      '설정에 minimo (photo) 링크를 추가했습니다.',
    ],
    Language.ja: [
      'アプリについて画面に minimo (photo) へのリンクを追加しました。',
      '設定に minimo (photo) へのリンクを追加しました。',
    ],
    Language.it: [
      'aggiunto un link a minimo (photo) nella schermata informazioni.',
      'aggiunto un link a minimo (photo) nelle impostazioni.',
    ],
    Language.tr: [
      'hakkında ekranına minimo (photo) bağlantısı eklendi.',
      'ayarlara minimo (photo) bağlantısı eklendi.',
    ],
  },
  '1.0.13': {
    Language.en: [
      'choose fractional video bitrates, such as 1.5 mbps, with 0.5 mbps slider steps. size estimates and compression preserve the selected value.',
      'compare the original and compressed video in one view. drag the divider to reveal the result.',
    ],
    Language.ru: [
      'выбирайте дробный битрейт, например 1,5 мбит/с, с шагом 0,5 мбит/с. оценка размера и сжатие сохраняют выбранное значение.',
      'сравнивайте оригинал и сжатое видео наложением. перемещайте разделитель, чтобы открыть результат.',
    ],
    Language.es: [
      'elige tasas de bits fraccionarias, como 1,5 mbps, con pasos de 0,5 mbps. la estimación del tamaño y la compresión conservan el valor elegido.',
      'compara el video original y el comprimido superpuestos. arrastra el separador para revelar el resultado.',
    ],
    Language.pt: [
      'escolha taxas de bits fracionárias, como 1,5 mbps, em passos de 0,5 mbps. a estimativa de tamanho e a compressão preservam o valor escolhido.',
      'compare o vídeo original e o comprimido sobrepostos. arraste o divisor para revelar o resultado.',
    ],
    Language.de: [
      'wähle gebrochene bitraten wie 1,5 mbit/s in schritten von 0,5 mbit/s. größenschätzung und komprimierung behalten den gewählten wert bei.',
      'vergleiche original und komprimiertes video übereinander. ziehe die trennlinie, um das ergebnis sichtbar zu machen.',
    ],
    Language.fr: [
      'choisissez des débits fractionnaires, comme 1,5 mbps, par pas de 0,5 mbps. l’estimation de taille et la compression conservent la valeur choisie.',
      'comparez la vidéo originale et la vidéo compressée par superposition. faites glisser le séparateur pour révéler le résultat.',
    ],
    Language.zh: [
      '支持以 0.5 mbps 为步长选择小数码率，例如 1.5 mbps。大小估算和压缩均保留所选值。',
      '将原始视频和压缩视频叠加比较。拖动分隔线即可查看压缩结果。',
    ],
    Language.hi: [
      '0.5 mbps के चरणों में 1.5 mbps जैसी दशमलव बिटरेट चुनें। आकार का अनुमान और संपीड़न चुने गए मान को बनाए रखते हैं।',
      'मूल और संपीड़ित वीडियो को एक-दूसरे पर रखकर तुलना करें। परिणाम देखने के लिए विभाजक खींचें।',
    ],
    Language.nl: [
      'kies decimale bitrates, zoals 1,5 mbps, in stappen van 0,5 mbps. de geschatte grootte en compressie behouden de gekozen waarde.',
      'vergelijk de originele en gecomprimeerde video over elkaar. sleep de scheidingslijn om het resultaat te onthullen.',
    ],
    Language.ko: [
      '0.5mbps 단위로 1.5mbps 같은 소수 비트레이트를 선택하세요. 크기 예상과 압축에 선택한 값이 그대로 적용됩니다.',
      '원본과 압축 동영상을 겹쳐서 비교하세요. 구분선을 드래그하여 결과를 확인하세요.',
    ],
    Language.ja: [
      '0.5 mbps刻みで1.5 mbpsなどの小数ビットレートを選べます。サイズ予測と圧縮に選択した値がそのまま使われます。',
      '元の動画と圧縮後の動画を重ねて比較できます。境界線をドラッグして結果を確認しましょう。',
    ],
    Language.it: [
      'scegli bitrate decimali, come 1,5 mbps, con incrementi di 0,5 mbps. la stima delle dimensioni e la compressione mantengono il valore scelto.',
      'confronta il video originale e quello compresso sovrapposti. trascina il divisore per mostrare il risultato.',
    ],
    Language.tr: [
      '0,5 mbps adımlarla 1,5 mbps gibi kesirli bit hızları seçin. boyut tahmini ve sıkıştırma seçilen değeri korur.',
      'orijinal ve sıkıştırılmış videoyu üst üste karşılaştırın. sonucu görmek için ayırıcıyı sürükleyin.',
    ],
  },
  '1.0.12': {
    Language.en: [
      'temporary videos are now cleaned up automatically when you leave a batch. videos saved to your gallery stay safe.',
    ],
    Language.ru: [
      'временные видео теперь удаляются автоматически после выхода из партии. сохранённые в галерею видео остаются.',
    ],
    Language.es: [
      'los videos temporales ahora se eliminan automáticamente al salir de un lote. los videos guardados en la galería se conservan.',
    ],
    Language.pt: [
      'os vídeos temporários agora são removidos automaticamente ao sair de um lote. os vídeos salvos na galeria são mantidos.',
    ],
    Language.de: [
      'temporäre videos werden jetzt beim verlassen eines stapels automatisch gelöscht. in der galerie gespeicherte videos bleiben erhalten.',
    ],
    Language.fr: [
      'les vidéos temporaires sont désormais supprimées automatiquement lorsque vous quittez un lot. les vidéos enregistrées dans la galerie sont conservées.',
    ],
    Language.zh: ['离开批次后，临时视频现在会自动清理。已保存到相册的视频不会被删除。'],
    Language.hi: [
      'बैच से बाहर निकलने पर अस्थायी वीडियो अब अपने आप हट जाते हैं। गैलरी में सहेजे गए वीडियो सुरक्षित रहते हैं।',
    ],
    Language.nl: [
      'tijdelijke video’s worden nu automatisch verwijderd wanneer je een batch verlaat. video’s die in je galerij zijn opgeslagen blijven behouden.',
    ],
    Language.ko: ['작업 화면을 나가면 임시 동영상이 자동으로 정리됩니다. 갤러리에 저장한 동영상은 유지됩니다.'],
    Language.ja: ['処理画面を閉じると、一時動画が自動的に削除されます。ギャラリーに保存した動画は残ります。'],
    Language.it: [
      'i video temporanei vengono ora eliminati automaticamente quando esci da un gruppo. i video salvati nella galleria vengono conservati.',
    ],
    Language.tr: [
      'bir gruptan çıktığınızda geçici videolar artık otomatik olarak temizlenir. galeriye kaydedilen videolar korunur.',
    ],
  },
  '1.0.11': {
    Language.en: [
      'choose any whole bitrate from 1–20 mbps with a new hand-drawn slider, haptic feedback, and a quick return to automatic.',
    ],
    Language.ru: [
      'выбирайте любой целый битрейт от 1 до 20 мбит/с рисованным слайдером с тактильным откликом и быстрым возвратом к автоматическому режиму.',
    ],
    Language.es: [
      'elige cualquier tasa de bits entera de 1 a 20 mbps con un nuevo deslizador de estilo dibujado a mano, respuesta háptica y acceso rápido al modo automático.',
    ],
    Language.pt: [
      'escolha qualquer taxa de bits inteira de 1 a 20 mbps com um novo controle deslizante desenhado à mão, resposta tátil e retorno rápido ao modo automático.',
    ],
    Language.de: [
      'wähle jede ganzzahlige bitrate von 1 bis 20 mbit/s mit einem neuen handgezeichneten schieberegler, haptischem feedback und schnellem wechsel zurück zur automatik.',
    ],
    Language.fr: [
      'choisissez un débit entier de 1 à 20 mbit/s avec un nouveau curseur dessiné à la main, un retour haptique et un accès rapide au mode automatique.',
    ],
    Language.zh: ['使用全新手绘风格滑块选择 1–20 mbps 的任意整数码率，支持触觉反馈，并可快速返回自动模式。'],
    Language.hi: [
      'नए हाथ से बनाए गए शैली वाले स्लाइडर से 1 से 20 mbps तक कोई भी पूर्णांक बिटरेट चुनें, हैप्टिक फ़ीडबैक पाएँ और आसानी से ऑटो मोड पर लौटें।',
    ],
    Language.nl: [
      'kies elke gehele bitrate van 1 tot 20 mbps met een nieuwe handgetekende schuifregelaar, haptische feedback en een snelle terugkeer naar automatisch.',
    ],
    Language.ko: [
      '새로운 손그림 스타일 슬라이더로 1~20mbps의 정수 비트레이트를 선택하세요. 햅틱 피드백과 자동 모드로 빠르게 돌아가는 기능을 제공합니다.',
    ],
    Language.ja: [
      '手描き風の新しいスライダーで、1〜20 mbpsの整数ビットレートを選べます。触覚フィードバックと自動モードへの素早い切り替えに対応しました。',
    ],
    Language.it: [
      'scegli qualsiasi bitrate intero da 1 a 20 mbps con un nuovo cursore disegnato a mano, feedback aptico e ritorno rapido alla modalità automatica.',
    ],
    Language.tr: [
      'yeni el çizimi tarzındaki kaydırıcıyla 1–20 mbps arasında herhangi bir tam sayı bit hızı seçin; dokunsal geri bildirim ve otomatik moda hızlı dönüş de mevcut.',
    ],
  },
  '1.0.10': {
    Language.en: ['technical update.'],
    Language.ru: ['техническое обновление.'],
    Language.es: ['actualización técnica.'],
    Language.pt: ['atualização técnica.'],
    Language.de: ['technische aktualisierung.'],
    Language.fr: ['mise à jour technique.'],
    Language.zh: ['技术更新。'],
    Language.hi: ['तकनीकी अपडेट।'],
    Language.nl: ['technische update.'],
    Language.ko: ['기술 업데이트.'],
    Language.ja: ['技術的な更新。'],
    Language.it: ['aggiornamento tecnico.'],
    Language.tr: ['teknik güncelleme.'],
  },
  '1.0.9': {
    Language.en: ['added manual video bitrate options up to 20 mbps.'],
    Language.ru: ['добавили ручной выбор битрейта видео до 20 мбит/с.'],
    Language.es: [
      'se añadieron opciones manuales de tasa de bits de video de hasta 20 mbps.',
    ],
    Language.pt: [
      'foram adicionadas opções manuais de taxa de bits de vídeo de até 20 mbps.',
    ],
    Language.de: ['manuelle video-bitraten bis zu 20 mbit/s hinzugefügt.'],
    Language.fr: ['ajout de débits vidéo manuels jusqu’à 20 mbit/s.'],
    Language.zh: ['新增最高 20 mbps 的手动视频比特率选项。'],
    Language.hi: ['20 mbps तक मैन्युअल वीडियो बिटरेट विकल्प जोड़े गए।'],
    Language.nl: ['handmatige videobitrates tot 20 mbps toegevoegd.'],
    Language.ko: ['최대 20mbps 수동 동영상 비트레이트 옵션을 추가했습니다.'],
    Language.ja: ['最大20 mbpsの手動ビデオビットレート設定を追加しました。'],
    Language.it: ['aggiunte opzioni manuali di bitrate video fino a 20 mbps.'],
    Language.tr: [
      '20 mbps’ye kadar manuel video bit hızı seçenekleri eklendi.',
    ],
  },
  '1.0.8': {
    Language.en: [
      'restored the familiar high, medium, and low names for basic compression.',
      'added local statistics for compressed videos and saved space.',
    ],
    Language.ru: [
      'вернули привычные названия базовых режимов сжатия: «высокое», «среднее» и «низкое».',
      'добавили локальную статистику с количеством сжатых видео и сэкономленного места.',
    ],
    Language.es: [
      'recuperamos los nombres habituales alta, media y baja para la compresión básica.',
      'añadimos estadísticas locales de vídeos comprimidos y espacio ahorrado.',
    ],
    Language.pt: [
      'restauramos os nomes conhecidos alta, média e baixa para a compressão básica.',
      'adicionamos estatísticas locais de vídeos comprimidos e espaço economizado.',
    ],
    Language.de: [
      'die vertrauten bezeichnungen hoch, mittel und niedrig für die basiskomprimierung sind zurück.',
      'lokale statistiken für komprimierte videos und eingesparten speicherplatz wurden hinzugefügt.',
    ],
    Language.fr: [
      'les noms familiers haute, moyenne et basse sont de retour pour la compression de base.',
      'ajout de statistiques locales sur les vidéos compressées et l’espace économisé.',
    ],
    Language.zh: ['基础压缩恢复为熟悉的“高”“中”“低”名称。', '新增本地统计，显示已压缩视频数量和节省的空间。'],
    Language.hi: [
      'बुनियादी कंप्रेशन के लिए परिचित उच्च, मध्यम और कम नाम वापस लाए गए हैं।',
      'कंप्रेस किए गए वीडियो और बचाई गई जगह के लिए लोकल आँकड़े जोड़े गए हैं।',
    ],
    Language.nl: [
      'de vertrouwde namen hoog, gemiddeld en laag zijn terug voor basiscompressie.',
      'lokale statistieken toegevoegd voor gecomprimeerde video’s en bespaarde ruimte.',
    ],
    Language.ko: [
      '기본 압축에 익숙한 높음, 중간, 낮음 이름을 다시 적용했습니다.',
      '압축한 동영상 수와 절약한 공간을 보여 주는 로컬 통계를 추가했습니다.',
    ],
    Language.ja: [
      '基本圧縮の名称を、なじみのある「高」「中」「低」に戻しました。',
      '圧縮した動画数と節約した容量を表示するローカル統計を追加しました。',
    ],
    Language.it: [
      'abbiamo ripristinato i nomi familiari alta, media e bassa per la compressione di base.',
      'aggiunte statistiche locali sui video compressi e lo spazio risparmiato.',
    ],
    Language.tr: [
      'temel sıkıştırma için bilinen yüksek, orta ve düşük adları geri getirildi.',
      'sıkıştırılan videolar ve kazanılan alan için yerel istatistikler eklendi.',
    ],
  },
  '1.0.7': {
    Language.en: [
      'added video import through the system share menu and shortcuts.',
      'moved quality, balanced, and smaller to the main settings. bitrate and frame rate are now in advanced.',
      'improved the import screen and compressed-size estimates.',
    ],
    Language.ru: [
      'добавили импорт видео через системное меню «поделиться» и быстрые команды.',
      'перенесли режимы «качество», «баланс» и «меньше» в основные настройки, а битрейт и частоту кадров — в расширенные.',
      'улучшили экран импорта и расчёт итогового размера видео.',
    ],
    Language.es: [
      'añadimos la importación de videos desde el menú compartir y los atajos.',
      'movimos calidad, equilibrado y más pequeño a los ajustes principales, y la tasa de bits y la frecuencia de imagen a avanzado.',
      'mejoramos la pantalla de importación y el cálculo del tamaño final.',
    ],
    Language.pt: [
      'adicionamos a importação de vídeos pelo menu compartilhar e por atalhos.',
      'movemos qualidade, equilibrado e menor para as configurações principais, e a taxa de bits e a taxa de quadros para avançado.',
      'melhoramos a tela de importação e o cálculo do tamanho final.',
    ],
    Language.de: [
      'videos lassen sich jetzt über das teilen-menü und kurzbefehle importieren.',
      'qualität, ausgewogen und kleiner befinden sich jetzt in den haupteinstellungen, bitrate und bildrate unter erweitert.',
      'die importansicht und die berechnung der endgültigen größe wurden verbessert.',
    ],
    Language.fr: [
      'ajout de l’importation de vidéos depuis le menu partager et les raccourcis.',
      'les modes qualité, équilibré et plus petit sont maintenant dans les réglages principaux, et le débit et la fréquence d’images dans avancé.',
      'amélioration de l’écran d’importation et du calcul de la taille finale.',
    ],
    Language.zh: [
      '现在可以通过系统分享菜单和快捷指令导入视频。',
      '“质量”“均衡”和“更小”已移至主要设置，比特率和帧率已移至高级设置。',
      '改进了导入界面和最终文件大小的估算。',
    ],
    Language.hi: [
      'अब सिस्टम शेयर मेन्यू और शॉर्टकट से वीडियो इंपोर्ट किए जा सकते हैं।',
      'क्वालिटी, संतुलित और छोटा मोड अब मुख्य सेटिंग्स में हैं, जबकि बिटरेट और फ़्रेम रेट उन्नत सेटिंग्स में हैं।',
      'इंपोर्ट स्क्रीन और अंतिम फ़ाइल आकार के अनुमान को बेहतर बनाया गया है।',
    ],
    Language.nl: [
      'video’s kunnen nu worden geïmporteerd via het deelmenu en opdrachten.',
      'kwaliteit, gebalanceerd en kleiner staan nu in de hoofdinstellingen, en bitrate en beeldsnelheid onder geavanceerd.',
      'het importscherm en de berekening van de uiteindelijke grootte zijn verbeterd.',
    ],
    Language.ko: [
      '이제 시스템 공유 메뉴와 단축어를 통해 동영상을 가져올 수 있습니다.',
      '화질, 균형, 더 작게 모드는 기본 설정으로, 비트레이트와 프레임 레이트는 고급 설정으로 옮겼습니다.',
      '가져오기 화면과 최종 파일 크기 계산을 개선했습니다.',
    ],
    Language.ja: [
      'システムの共有メニューとショートカットから動画を読み込めるようになりました。',
      '「画質」「バランス」「より小さく」を基本設定に、ビットレートとフレームレートを詳細設定に移動しました。',
      '読み込み画面と最終ファイルサイズの計算を改善しました。',
    ],
    Language.it: [
      'ora puoi importare video dal menu condividi e dai comandi rapidi.',
      'abbiamo spostato qualità, bilanciato e più piccolo nelle impostazioni principali, e bitrate e frequenza dei fotogrammi in avanzato.',
      'abbiamo migliorato la schermata di importazione e il calcolo delle dimensioni finali.',
    ],
    Language.tr: [
      'sistem paylaşım menüsü ve kestirmeler üzerinden video aktarma özelliği eklendi.',
      'kalite, dengeli ve daha küçük ana ayarlara; bit hızı ve kare hızı ise gelişmiş ayarlara taşındı.',
      'aktarma ekranı ve nihai dosya boyutu hesaplaması iyileştirildi.',
    ],
  },
  '1.0.6': {
    Language.en: [
      'keep the screen awake while selected videos are loading when enabled in settings.',
      'retry video selection immediately after leaving an import in progress.',
      'open only one video-source sheet and close it fully before loading begins.',
      'keep the import loader still while its progress number changes.',
      'show a smoother, centered loading indicator.',
      'avoid showing an optimistic size that later returns to the original size.',
      'preserve embedded capture date and gps for videos chosen through the private ios picker without expanding photos access.',
    ],
    Language.ru: [
      'экран теперь остаётся включённым во время загрузки выбранных видео, если это разрешено в настройках.',
      'выбор видео теперь можно сразу повторить после выхода во время загрузки.',
      'окно выбора источника видео теперь открывается один раз и полностью закрывается до начала загрузки.',
      'индикатор импорта больше не смещается при изменении числа загруженных видео.',
      'индикатор загрузки теперь плавный и точно отцентрирован.',
      'предварительный размер больше не уменьшается преждевременно и не возвращается к исходному после расчёта.',
      'дата съёмки и gps сохраняются для видео из приватного ios-пикера без расширения доступа к фото.',
    ],
    Language.es: [
      'mantén la pantalla encendida mientras se cargan los videos seleccionados si está activado en ajustes.',
      'vuelve a seleccionar videos inmediatamente después de salir durante una importación.',
      'abre una sola hoja de origen de video y ciérrala por completo antes de iniciar la carga.',
      'mantén fijo el indicador de importación mientras cambia el progreso.',
      'muestra un indicador de carga más fluido y centrado.',
      'evita mostrar un tamaño optimista que luego vuelve al tamaño original.',
      'conserva la fecha de captura y el gps de videos elegidos con el selector privado de ios sin ampliar el acceso a fotos.',
    ],
    Language.pt: [
      'mantenha a tela ligada durante o carregamento dos vídeos selecionados quando ativado nos ajustes.',
      'selecione vídeos novamente logo após sair durante uma importação.',
      'abra apenas uma folha de origem do vídeo e feche-a totalmente antes do carregamento.',
      'mantenha o indicador de importação parado enquanto o progresso muda.',
      'mostre um indicador de carregamento mais suave e centralizado.',
      'evite mostrar um tamanho otimista que depois volta ao tamanho original.',
      'preserve a data de captura e o gps de vídeos escolhidos pelo seletor privado do ios sem ampliar o acesso às fotos.',
    ],
    Language.de: [
      'der bildschirm bleibt beim laden ausgewählter videos aktiv, wenn dies in den einstellungen aktiviert ist.',
      'die videoauswahl kann direkt nach dem verlassen eines laufenden imports wiederholt werden.',
      'öffne nur ein videoquellen-fenster und schließe es vor dem laden vollständig.',
      'halte die importanzeige ruhig, während sich der fortschrittswert ändert.',
      'zeige eine gleichmäßigere, zentrierte ladeanzeige.',
      'vermeide eine optimistische größenanzeige, die später zur originalgröße zurückspringt.',
      'bewahre aufnahmedatum und gps für videos aus dem privaten ios-auswahldialog ohne erweiterten fotozugriff.',
    ],
    Language.fr: [
      'gardez l’écran allumé pendant le chargement des vidéos sélectionnées lorsque l’option est activée.',
      'relancez immédiatement la sélection de vidéos après avoir quitté un import en cours.',
      'n’ouvrez qu’une seule feuille de source vidéo et fermez-la complètement avant le chargement.',
      'gardez l’indicateur d’import immobile lorsque la progression change.',
      'affichez un indicateur de chargement plus fluide et centré.',
      'évitez d’afficher une taille optimiste qui revient ensuite à la taille d’origine.',
      'conservez la date de capture et le gps des vidéos choisies avec le sélecteur privé ios sans élargir l’accès à photos.',
    ],
    Language.zh: [
      '在设置中启用后，加载所选视频时屏幕会保持亮起。',
      '退出正在进行的导入后可立即重新选择视频。',
      '视频来源面板只会打开一次，并在加载前完全关闭。',
      '导入进度数字变化时，加载指示器会保持稳定。',
      '加载指示器现在更流畅且保持居中。',
      '不再先显示过于乐观的大小，再跳回原始大小。',
      '通过 ios 私密选择器选取的视频可保留拍摄日期和 gps，无需扩大照片访问权限。',
    ],
    Language.hi: [
      'सेटिंग चालू होने पर चुने गए वीडियो लोड होते समय स्क्रीन चालू रहती है।',
      'चल रहे इंपोर्ट से बाहर निकलने के बाद वीडियो तुरंत दोबारा चुनें।',
      'केवल एक वीडियो स्रोत शीट खोलें और लोडिंग से पहले उसे पूरी तरह बंद करें।',
      'प्रगति संख्या बदलते समय इंपोर्ट लोडर स्थिर रखें।',
      'अधिक सहज और बीच में स्थित लोडिंग संकेत दिखाएँ।',
      'ऐसा आशावादी आकार न दिखाएँ जो बाद में मूल आकार पर लौट जाए।',
      'फ़ोटो एक्सेस बढ़ाए बिना निजी ios पिकर से चुने वीडियो की कैप्चर तारीख और gps सुरक्षित रखें।',
    ],
    Language.nl: [
      'houd het scherm aan terwijl geselecteerde video’s laden wanneer dit in instellingen is ingeschakeld.',
      'selecteer direct opnieuw video’s nadat je een actieve import hebt verlaten.',
      'open slechts één videobronvenster en sluit het volledig voordat het laden begint.',
      'houd de importindicator stil terwijl het voortgangsgetal verandert.',
      'toon een vloeiendere, gecentreerde laadindicator.',
      'toon geen optimistische grootte die later terugspringt naar het origineel.',
      'behoud opnamedatum en gps van video’s uit de privé-ios-kiezer zonder foto’s-toegang uit te breiden.',
    ],
    Language.ko: [
      '설정이 활성화되면 선택한 동영상을 불러오는 동안 화면이 켜진 상태로 유지됩니다.',
      '진행 중인 가져오기를 종료한 뒤 동영상을 즉시 다시 선택할 수 있습니다.',
      '동영상 소스 창을 한 번만 열고 로딩 전에 완전히 닫습니다.',
      '진행률 숫자가 바뀌어도 가져오기 로더가 흔들리지 않습니다.',
      '더 부드럽고 중앙에 맞춘 로딩 표시를 보여 줍니다.',
      '낙관적인 크기를 먼저 표시했다가 원본 크기로 돌아가는 현상을 방지합니다.',
      '사진 접근 권한을 넓히지 않고 비공개 ios 선택기로 고른 동영상의 촬영 날짜와 gps를 보존합니다.',
    ],
    Language.ja: [
      '設定が有効な場合、選択した動画の読み込み中も画面が点灯したままになります。',
      '読み込み中に画面を離れても、すぐに動画を選び直せるようになりました。',
      '動画ソースのシートを一度だけ開き、読み込み前に完全に閉じます。',
      '進行数が変わっても読み込みインジケーターが動かないようにしました。',
      'より滑らかで中央に揃った読み込み表示になりました。',
      '楽観的なサイズを先に表示して元のサイズへ戻ることがないようにしました。',
      '写真へのアクセスを広げず、非公開iosピッカーで選んだ動画の撮影日時とgpsを保持します。',
    ],
    Language.it: [
      'mantieni lo schermo acceso durante il caricamento dei video selezionati se l’opzione è attiva.',
      'seleziona nuovamente i video subito dopo aver lasciato un’importazione in corso.',
      'apri un solo pannello per la sorgente video e chiudilo completamente prima del caricamento.',
      'mantieni fermo l’indicatore di importazione mentre cambia il progresso.',
      'mostra un indicatore di caricamento più fluido e centrato.',
      'evita di mostrare una dimensione ottimistica che poi torna a quella originale.',
      'conserva data di acquisizione e gps dei video scelti con il selettore privato ios senza ampliare l’accesso a foto.',
    ],
    Language.tr: [
      'ayarlar’da etkinleştirildiğinde seçilen videolar yüklenirken ekranı açık tutun.',
      'devam eden bir içe aktarmadan çıktıktan sonra video seçimini hemen yeniden deneyin.',
      'yalnızca bir video kaynağı sayfası açın ve yükleme başlamadan tamamen kapatın.',
      'ilerleme sayısı değişirken içe aktarma göstergesini sabit tutun.',
      'daha akıcı ve ortalanmış bir yükleme göstergesi gösterin.',
      'daha sonra orijinal boyuta dönen iyimser bir boyut göstermeyin.',
      'fotoğraflar erişimini genişletmeden özel ios seçicisinden alınan videoların çekim tarihi ve gps bilgisini koruyun.',
    ],
  },
  '1.0.5': {
    Language.en: [
      'reopen what’s new from the about screen.',
      'hold actions that require confirmation longer, with progress that slows near completion.',
      'see multiple notifications in a clear vertical stack instead of overlapping.',
    ],
    Language.ru: [
      'раздел «что нового» теперь можно снова открыть с экрана «о приложении».',
      'действия с подтверждением теперь требуют более долгого удержания, а прогресс замедляется ближе к завершению.',
      'несколько уведомлений теперь складываются в аккуратный вертикальный стек и не перекрывают друг друга.',
    ],
    Language.es: [
      'vuelve a abrir novedades desde la pantalla acerca de.',
      'mantén pulsadas durante más tiempo las acciones que requieren confirmación, con un progreso que se ralentiza al final.',
      'consulta varias notificaciones en una pila vertical clara en lugar de superpuestas.',
    ],
    Language.pt: [
      'abra novamente as novidades pela tela sobre.',
      'mantenha pressionadas por mais tempo as ações que exigem confirmação, com o progresso desacelerando perto do fim.',
      'veja várias notificações em uma pilha vertical organizada, sem sobreposição.',
    ],
    Language.de: [
      'öffne „neuigkeiten“ erneut über den info-bildschirm.',
      'halte aktionen mit bestätigung länger gedrückt; der fortschritt wird zum ende hin langsamer.',
      'mehrere benachrichtigungen erscheinen übersichtlich untereinander statt übereinander.',
    ],
    Language.fr: [
      'rouvrez les nouveautés depuis l’écran à propos.',
      'maintenez plus longtemps les actions nécessitant une confirmation, avec une progression qui ralentit vers la fin.',
      'consultez plusieurs notifications dans une pile verticale claire, sans chevauchement.',
    ],
    Language.zh: [
      '可从“关于”页面重新打开“更新内容”。',
      '需要确认的操作要按住更长时间，进度在接近完成时会逐渐减慢。',
      '多条通知会整齐地纵向排列，不再相互重叠。',
    ],
    Language.hi: [
      'अब परिचय स्क्रीन से नया क्या है फिर से खोलें।',
      'पुष्टि वाली कार्रवाइयों को अधिक देर तक दबाएँ; पूरा होने के पास प्रगति धीमी हो जाती है।',
      'कई सूचनाएँ अब एक-दूसरे पर चढ़ने के बजाय साफ़ लंबवत क्रम में दिखती हैं।',
    ],
    Language.nl: [
      'open wat is er nieuw opnieuw vanuit het infoscherm.',
      'houd acties met bevestiging langer ingedrukt; de voortgang vertraagt tegen het einde.',
      'meerdere meldingen staan overzichtelijk onder elkaar in plaats van over elkaar.',
    ],
    Language.ko: [
      '정보 화면에서 새로운 기능을 다시 열 수 있습니다.',
      '확인이 필요한 작업은 더 오래 눌러야 하며 완료에 가까워질수록 진행 속도가 느려집니다.',
      '여러 알림이 겹치지 않고 깔끔한 세로 스택으로 표시됩니다.',
    ],
    Language.ja: [
      '情報画面から「新機能」をもう一度開けるようになりました。',
      '確認が必要な操作はより長く押し続ける必要があり、完了に近づくほど進行がゆっくりになります。',
      '複数の通知が重ならず、見やすく縦に並ぶようになりました。',
    ],
    Language.it: [
      'riapri le novità dalla schermata informazioni.',
      'tieni premute più a lungo le azioni che richiedono conferma, con un avanzamento che rallenta verso la fine.',
      'visualizza più notifiche in una pila verticale ordinata, senza sovrapposizioni.',
    ],
    Language.tr: [
      'hakkında ekranından yenilikler bölümünü yeniden açın.',
      'onay gerektiren işlemleri daha uzun basılı tutun; ilerleme tamamlanmaya yakın yavaşlar.',
      'birden fazla bildirimi üst üste binmek yerine düzenli bir dikey yığında görün.',
    ],
  },
  '1.0.4': {
    Language.en: [
      'keep compression size estimates updating for batches over 100 videos, with a loading indicator while recalculating.',
      'see a clearer explanation before photos asks to delete original videos during replacement.',
      'leave an active video import after confirmation, without flashing empty settings when the picker is cancelled.',
    ],
    Language.ru: [
      'оценка размера теперь обновляется и для пакетов больше 100 видео, а во время пересчёта показывается индикатор загрузки.',
      'перед запросом фото на удаление оригиналов теперь яснее указано, что удаляются именно исходные видео.',
      'из активной загрузки видео теперь можно выйти после подтверждения, а отмена выбора больше не показывает пустые настройки.',
    ],
    Language.es: [
      'la estimación de tamaño sigue actualizándose en lotes de más de 100 videos y muestra un indicador durante el recálculo.',
      'se muestra una explicación más clara antes de que fotos pida eliminar los videos originales al reemplazarlos.',
      'sal de una importación activa tras confirmarlo, sin que aparezcan ajustes vacíos al cancelar el selector.',
    ],
    Language.pt: [
      'a estimativa de tamanho continua atualizando em lotes com mais de 100 vídeos e mostra um indicador durante o recálculo.',
      'veja uma explicação mais clara antes que o fotos peça para excluir os vídeos originais durante a substituição.',
      'saia de uma importação ativa após confirmar, sem mostrar configurações vazias ao cancelar o seletor.',
    ],
    Language.de: [
      'die geschätzte größe wird auch bei stapeln mit über 100 videos aktualisiert; während der neuberechnung erscheint eine ladeanzeige.',
      'vor der löschabfrage von fotos wird klarer erklärt, dass beim ersetzen die originalvideos gelöscht werden.',
      'verlasse einen laufenden videoimport nach bestätigung, ohne dass beim abbrechen des pickers leere einstellungen aufblitzen.',
    ],
    Language.fr: [
      'l’estimation de la taille continue de se mettre à jour pour les lots de plus de 100 vidéos, avec un indicateur pendant le recalcul.',
      'une explication plus claire apparaît avant que photos demande de supprimer les vidéos originales lors du remplacement.',
      'quittez un import vidéo actif après confirmation, sans afficher brièvement des réglages vides si le sélecteur est annulé.',
    ],
    Language.zh: [
      '超过 100 个视频的批量任务也会持续更新预计大小，重新计算时会显示加载指示。',
      '替换视频时，在图库请求删除原视频前会显示更清晰的说明。',
      '确认后可退出正在进行的视频导入，取消选择器时也不会短暂显示空设置。',
    ],
    Language.hi: [
      '100 से अधिक वीडियो वाले बैच में भी अनुमानित आकार अपडेट होता है और दोबारा गणना के दौरान लोडिंग संकेत दिखता है।',
      'बदलने के दौरान फ़ोटो द्वारा मूल वीडियो हटाने की पुष्टि मांगने से पहले अब साफ़ जानकारी दिखती है।',
      'पुष्टि के बाद चल रहे वीडियो इंपोर्ट से बाहर निकलें; पिकर रद्द करने पर खाली सेटिंग्स नहीं दिखेंगी।',
    ],
    Language.nl: [
      "de geschatte grootte blijft ook bij batches van meer dan 100 video's bijgewerkt, met een laadindicator tijdens het herberekenen.",
      "voor foto's vraagt om de originele video's te verwijderen, verschijnt een duidelijkere uitleg.",
      "verlaat na bevestiging een actieve video-import, zonder dat lege instellingen opflitsen wanneer de picker wordt geannuleerd.",
    ],
    Language.ko: [
      '100개가 넘는 동영상 묶음에서도 예상 크기가 계속 업데이트되며 다시 계산하는 동안 로딩 표시가 나타납니다.',
      '교체할 때 사진 앱이 원본 동영상 삭제를 요청하기 전에 더 명확한 설명이 표시됩니다.',
      '확인 후 진행 중인 동영상 가져오기를 나갈 수 있으며 선택기를 취소해도 빈 설정이 잠깐 표시되지 않습니다.',
    ],
    Language.ja: [
      '100本を超える動画の一括処理でも推定サイズが更新され、再計算中は読み込み表示が出ます。',
      '置き換え時に写真アプリが元の動画の削除を求める前に、より分かりやすい説明が表示されます。',
      '確認後に進行中の動画読み込みを終了でき、選択をキャンセルしても空の設定画面が一瞬表示されません。',
    ],
    Language.it: [
      'la stima delle dimensioni continua ad aggiornarsi anche per gruppi di oltre 100 video, con un indicatore durante il ricalcolo.',
      'prima che foto chieda di eliminare i video originali durante la sostituzione viene mostrata una spiegazione più chiara.',
      'esci da un’importazione video attiva dopo la conferma, senza mostrare impostazioni vuote quando annulli il selettore.',
    ],
    Language.tr: [
      "100'den fazla videolu gruplarda da tahmini boyut güncellenir ve yeniden hesaplama sırasında yükleme göstergesi görünür.",
      'değiştirme sırasında fotoğraflar orijinal videoları silmek için izin istemeden önce daha açık bir açıklama gösterilir.',
      'onaydan sonra etkin video içe aktarımından çıkın; seçici iptal edildiğinde boş ayarlar kısa süreliğine görünmez.',
    ],
  },
  '1.0.3': {
    Language.en: [
      'use minimo in spanish, brazilian portuguese, german, french, simplified chinese, hindi, dutch, korean, japanese, italian, and turkish.',
      'switch between simple and advanced compression with a clearer, more accessible control and reduced-motion support.',
    ],
    Language.ru: [
      'можно пользоваться minimo на испанском, бразильском португальском, немецком, французском, упрощённом китайском, хинди, нидерландском, корейском, японском, итальянском и турецком.',
      'переключатель простого и расширенного режимов стал понятнее, доступнее и учитывает настройку уменьшения движения.',
    ],
    Language.es: [
      'usa minimo en español, portugués de brasil, alemán, francés, chino simplificado, hindi, neerlandés, coreano, japonés, italiano y turco.',
      'cambia entre la compresión simple y avanzada con un control más claro, accesible y compatible con movimiento reducido.',
    ],
    Language.pt: [
      'use o minimo em espanhol, português do brasil, alemão, francês, chinês simplificado, hindi, neerlandês, coreano, japonês, italiano e turco.',
      'alterne entre compressão simples e avançada com um controle mais claro, acessível e compatível com movimento reduzido.',
    ],
    Language.de: [
      'nutze minimo auf spanisch, brasilianischem portugiesisch, deutsch, französisch, vereinfachtem chinesisch, hindi, niederländisch, koreanisch, japanisch, italienisch und türkisch.',
      'wechsle mit einer klareren, barrierefreien steuerung und unterstützung für reduzierte bewegung zwischen einfacher und erweiterter komprimierung.',
    ],
    Language.fr: [
      'utilisez minimo en espagnol, portugais brésilien, allemand, français, chinois simplifié, hindi, néerlandais, coréen, japonais, italien et turc.',
      'basculez entre la compression simple et avancée avec une commande plus claire, accessible et compatible avec la réduction des animations.',
    ],
    Language.zh: [
      '现可使用西班牙语、巴西葡萄牙语、德语、法语、简体中文、印地语、荷兰语、韩语、日语、意大利语和土耳其语使用 minimo。',
      '使用更清晰、更无障碍且支持减少动效的控件，在简单和高级压缩之间切换。',
    ],
    Language.hi: [
      'अब minimo का इस्तेमाल स्पेनिश, ब्राज़ीलियाई पुर्तगाली, जर्मन, फ़्रेंच, सरलीकृत चीनी, हिंदी, डच, कोरियाई, जापानी, इतालवी और तुर्की में करें।',
      'सरल और उन्नत कंप्रेशन के बीच अब एक साफ़, सुलभ और कम मोशन का समर्थन करने वाले कंट्रोल से बदलें।',
    ],
    Language.nl: [
      'gebruik minimo in het spaans, braziliaans portugees, duits, frans, vereenvoudigd chinees, hindi, nederlands, koreaans, japans, italiaans en turks.',
      'wissel tussen eenvoudige en geavanceerde compressie met een duidelijkere, toegankelijke bediening en ondersteuning voor minder beweging.',
    ],
    Language.ko: [
      'minimo를 스페인어, 브라질 포르투갈어, 독일어, 프랑스어, 중국어 간체, 힌디어, 네덜란드어, 한국어, 일본어, 이탈리아어, 튀르키예어로 사용하세요.',
      '더 명확하고 접근성이 높으며 모션 줄이기를 지원하는 컨트롤로 간단 압축과 고급 압축을 전환하세요.',
    ],
    Language.ja: [
      'minimoをスペイン語、ブラジルポルトガル語、ドイツ語、フランス語、簡体中国語、ヒンディー語、オランダ語、韓国語、日本語、イタリア語、トルコ語で利用できます。',
      'より分かりやすくアクセシブで、動きを減らす設定にも対応したコントロールで、シンプル圧縮と詳細圧縮を切り替えられます。',
    ],
    Language.it: [
      'usa minimo in spagnolo, portoghese brasiliano, tedesco, francese, cinese semplificato, hindi, olandese, coreano, giapponese, italiano e turco.',
      'passa dalla compressione semplice a quella avanzata con un controllo più chiaro, accessibile e compatibile con la riduzione del movimento.',
    ],
    Language.tr: [
      "minimo'yu i̇spanyolca, brezilya portekizcesi, almanca, fransızca, basitleştirilmiş çince, hintçe, felemenkçe, korece, japonca, i̇talyanca ve türkçe kullanın.",
      'daha net, erişilebilir ve azaltılmış hareket desteği sunan denetimle basit ve gelişmiş sıkıştırma arasında geçiş yapın.',
    ],
  },
  '1.0.2': {
    Language.en: [
      'adjust compression settings while cloud-backed or large videos import; the compress button shows progress until they are ready.',
      'see a loading screen instead of empty settings until video selection is confirmed.',
      'see when compressed videos are saved and avoid saving them twice.',
      'read long update notes with clear fading at the scroll edges.',
    ],
    Language.ru: [
      'можно менять настройки, пока видео загружается из облака или копируется; кнопка сжатия показывает прогресс до готовности.',
      'до подтверждения выбора видео показывается загрузка, а не пустой экран настроек.',
      'после сохранения сжатого видео кнопка показывает результат и не сохраняет его повторно.',
      'у длинного списка изменений теперь видны плавные края прокрутки.',
    ],
  },
  '1.0.1': {
    Language.en: [
      'share minimo with friends.',
      'rate the app from the about screen.',
      'get a gentle review prompt after successful conversions.',
      'see update prompts when a new store version is available.',
      'fine-tune bitrate, frame rate, and h.264 or hevc codec.',
      'preview original and compressed videos side by side.',
      'get more accurate size estimates and smoother preview scrubbing.',
      'compress portrait screen recordings without squeezing.',
      'choose how saved videos handle originals while preserving gallery metadata where supported.',
      'save compressed videos directly as new gallery items.',
      'avoid replacing or deleting the same gallery video twice.',
      'see clear messages when saving, deleting, or sharing fails.',
    ],
    Language.ru: [
      'можно поделиться minimo с друзьями.',
      'можно оценить приложение из экрана о приложении.',
      'после успешных конвертаций появляется аккуратный запрос оценки.',
      'приложение подсказывает, когда в магазине доступно обновление.',
      'можно настроить битрейт, частоту кадров и кодек h.264 или hevc.',
      'можно сравнить исходное и сжатое видео рядом.',
      'оценка размера стала точнее, а перемотка предпросмотра — плавнее.',
      'портретные записи экрана больше не сжимаются по ширине.',
      'можно выбрать способ сохранения оригинала с переносом метаданных галереи, где это поддерживается.',
      'сжатые видео сразу сохраняются как новые элементы галереи.',
      'приложение больше не заменяет и не удаляет одно видео повторно.',
      'ошибки сохранения, удаления и отправки теперь описаны понятнее.',
    ],
  },
};

List<String> unseenChanges({
  required String lastSeen,
  required String current,
  required Language language,
  Changelog changelog = _changelog,
}) {
  final lastSeenVersion = _tryParseVersion(lastSeen) ?? Version(0, 0, 0);
  final currentVersion = _tryParseVersion(current);
  if (currentVersion == null) return const [];

  final result = <String>[];
  final entries = <({Version version, Map<Language, List<String>> texts})>[];
  for (final entry in changelog.entries) {
    final entryVersion = _tryParseVersion(entry.key);
    if (entryVersion == null) continue;
    entries.add((version: entryVersion, texts: entry.value));
  }
  entries.sort((a, b) => a.version.compareTo(b.version));

  for (final entry in entries) {
    if (entry.version > lastSeenVersion && entry.version <= currentVersion) {
      result.addAll(entry.texts[language] ?? entry.texts[Language.en] ?? []);
    }
  }

  return result;
}

Version? _tryParseVersion(String value) {
  try {
    return Version.parse(value);
  } on FormatException {
    return null;
  }
}

class ChangelogUpdate {
  final String version;
  final List<String> changes;

  const ChangelogUpdate({required this.version, required this.changes});
}

class ChangelogService {
  static const _lastSeenVersionKey = 'last_seen_version';
  static final instance = ChangelogService();

  final Future<PackageInfo> Function() _packageInfo;
  final Future<SharedPreferences> Function() _preferences;

  String? _currentVersion;

  ChangelogService({
    Future<PackageInfo> Function()? packageInfo,
    Future<SharedPreferences> Function()? preferences,
  }) : _packageInfo = packageInfo ?? PackageInfo.fromPlatform,
       _preferences = preferences ?? SharedPreferences.getInstance;

  Future<ChangelogUpdate?> currentUpdate({required Language language}) async {
    final current = (await _packageInfo()).version;
    _currentVersion = current;
    final texts = _changelog[current];
    if (texts == null) return null;

    final changes = texts[language] ?? texts[Language.en] ?? const [];
    if (changes.isEmpty) return null;
    return ChangelogUpdate(version: current, changes: changes);
  }

  Future<ChangelogUpdate?> initialize({required Language language}) async {
    final current = (await _packageInfo()).version;
    _currentVersion = current;

    final prefs = await _preferences();
    final lastSeenRaw = prefs.getString(_lastSeenVersionKey);
    final lastSeen = lastSeenRaw == null
        ? null
        : (_tryParseVersion(lastSeenRaw) == null ? null : lastSeenRaw);

    if (lastSeenRaw != null && lastSeen == null) {
      await prefs.remove(_lastSeenVersionKey);
    }

    if (lastSeen == null && await FirstLaunchService.shouldShowOnboarding()) {
      await prefs.setString(_lastSeenVersionKey, current);
      return null;
    }

    if (lastSeen == current) return null;

    final changes = unseenChanges(
      lastSeen: lastSeen ?? '0.0.0',
      current: current,
      language: language,
    );

    if (changes.isEmpty) {
      await prefs.setString(_lastSeenVersionKey, current);
      return null;
    }

    return ChangelogUpdate(version: current, changes: changes);
  }

  Future<void> markCurrentVersionSeen() async {
    final version = _currentVersion ?? (await _packageInfo()).version;
    final prefs = await _preferences();
    await prefs.setString(_lastSeenVersionKey, version);
  }

  Future<void> dismiss() async {
    await markCurrentVersionSeen();
  }
}
