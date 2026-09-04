import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/changelog_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

PackageInfo _packageInfo(String version) => PackageInfo(
  appName: 'minimo',
  packageName: 'com.khlebobul.minimo_video',
  version: version,
  buildNumber: '1',
);

void main() {
  test('bundled 1.0.4 changelog is localized for every language', () {
    final changes = {
      for (final language in Language.values)
        unseenChanges(
          lastSeen: '1.0.3',
          current: '1.0.4',
          language: language,
        ).join('\n'),
    };

    expect(changes, hasLength(Language.values.length));
    expect(changes.every((change) => change.isNotEmpty), isTrue);
  });

  test('every language code resolves to its language', () {
    for (final language in Language.values) {
      expect(Language.fromCode(language.code), language);
    }
  });

  test('bundled 1.0.2 changelog is shown after 1.0.1', () {
    expect(
      unseenChanges(lastSeen: '1.0.1', current: '1.0.2', language: Language.en),
      hasLength(4),
    );
  });

  test('unseenChanges returns every version between last seen and current', () {
    final changes = unseenChanges(
      lastSeen: '1.2.0',
      current: '1.5.0',
      language: Language.en,
      changelog: const {
        '1.2.0': {
          Language.en: ['old'],
        },
        '1.3.0': {
          Language.en: ['middle'],
        },
        '1.5.0': {
          Language.en: ['latest'],
        },
      },
    );

    expect(changes, ['middle', 'latest']);
  });

  test('unseenChanges treats malformed lastSeen as never seen', () {
    final changes = unseenChanges(
      lastSeen: 'not-a-version',
      current: '1.5.0',
      language: Language.en,
      changelog: const {
        '1.3.0': {
          Language.en: ['middle'],
        },
        '1.5.0': {
          Language.en: ['latest'],
        },
      },
    );

    expect(changes, ['middle', 'latest']);
  });

  test('initialize discards corrupt last_seen_version and continues', () async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'last_seen_version': 'corrupt',
    });
    final service = ChangelogService(
      packageInfo: () async => _packageInfo('1.0.1'),
    );

    final update = await service.initialize(language: Language.en);

    expect(update?.changes, isNotEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('last_seen_version'), isNull);
  });

  test('initialize skips first install and saves current version', () async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': false});
    final service = ChangelogService(
      packageInfo: () async => _packageInfo('1.0.0'),
    );

    expect(await service.initialize(language: Language.en), isNull);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('last_seen_version'), '1.0.0');
  });
}
