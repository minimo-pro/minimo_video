<div align="center">


<!-- TODO: Add store links after release. -->
![App Store](https://img.shields.io/badge/App_Store-414141?style=for-the-badge&logo=apple&logoColor=F1F1F1) ![Google Play](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=googleplay&logoColor=F1F1F1) [![Website](https://img.shields.io/badge/Website-414141?style=for-the-badge)](https://github.com/minimo-pro)

<img width="900" alt="minimo video screenshots" src="screenshots/github.png" />

minimo (video) is a free mobile app for shrinking videos directly on your device.
No cloud upload. No subscription. Your videos stay yours.

</div>


## Features

- Simple quality presets: high, medium, low
- Advanced controls: resolution and audio
- Batch compression
- Progress screen with time estimate
- Save and share compressed videos
- Optional album saving
- English and Russian localization

## Roadmap

- [x] Simple quality presets
- [x] Batch compression
- [x] Resolution and audio controls
- [x] Compression progress, cancellation, saving, and sharing
- [ ] Custom bitrate
- [ ] Frame rate control
- [ ] H.264 and HEVC codec selection
- [ ] Compression speed presets
- [ ] Metadata preservation

## Native compression pipeline

```mermaid
flowchart TD
    A[CompressBloc<br/>processes videos sequentially] --> B[VideoCompressorAdapter<br/>builds bitrate, resolution and audio config]
    B --> C[light_compressor_v2]
    C --> D{Native platform plugin}

    subgraph Android
        E[MediaCodec and MediaMuxer]
        E --> F[MP4 output]
    end

    subgraph iOS
        G[AVFoundation]
        G --> H[MP4 output]
    end

    D -->|Android| E
    D -->|iOS| G
    C -.->|progress stream| A
    F --> I[Native result]
    H --> I
    I --> J{Output is smaller?}
    J -->|Yes| K[Move MP4 to app output]
    J -->|No| L[Discard result and keep original]
```

Compression uses native platform APIs, not FFmpeg. Input, output, and intermediate files stay on the device.

### Why not FFmpeg?

Native Android codecs and AVFoundation keep the app smaller, use platform hardware acceleration, consume less battery, and avoid bundling another native runtime. They cover minimo's current goal: straightforward on-device video compression.

The trade-off is less low-level control and small output differences between Android and iOS. FFmpeg would make sense if the app needed identical cross-platform encoding, uncommon formats, or complex filter pipelines.

FFmpeg is available under LGPL or GPL depending on how it is built and which components are enabled. Shipping its binaries would require tracking that configuration and satisfying the corresponding redistribution, attribution, relinking, and source-code obligations. Using system Android and iOS codecs avoids distributing FFmpeg and keeps the app itself under the MIT License. Codec patent and store requirements may still apply independently.

## How to contribute

[![Contributing](https://img.shields.io/badge/Contributing-Guide-414141?style=for-the-badge)](CONTRIBUTING.md) [![Code of Conduct](https://img.shields.io/badge/Code_of_Conduct-Rules-414141?style=for-the-badge)](CODE_OF_CONDUCT.md)

## Credits

Video compression is powered by [light_compressor_v2](https://pub.dev/packages/light_compressor_v2). Respect and thanks to its maintainers and contributors.

Special thanks to [Kamran Bekirov](https://x.com/kamranbekirovyz) and his website [Flutter Pro Design](https://flutterpro.design/). I learned from and adapted many ideas from his work for myself and for this app.


## Contacts

[![@khlebobul](https://img.shields.io/badge/@khlebobul-414141?style=for-the-badge&logo=X&logoColor=F1F1F1)](https://x.com/khlebobul) [![Email - khlebobul@gmail.com](https://img.shields.io/badge/Email-khlebobul%40gmail.com-414141?style=for-the-badge&logo=Email&logoColor=F1F1F1)](mailto:khlebobul@gmail.com) [![@khlebobul_dev](https://img.shields.io/badge/%40khlebobul__dev-414141?style=for-the-badge&logo=Telegram&logoColor=F1F1F1)](https://t.me/khlebobul_dev) [![Personal - Website](https://img.shields.io/badge/Personal-Website-414141?style=for-the-badge&logo=Personal&logoColor=F1F1F1)](https://khlebobul.github.io/)

## License

[![LICENCE - MIT](https://img.shields.io/badge/LICENCE-MIT-414141?style=for-the-badge&logo=Licence&logoColor=F1F1F1)](https://github.com/minimo-pro/minimo_video/blob/main/LICENSE)
