<div align="center">

// TODO store links + website

<img width="900" alt="minimo video screenshots" src="screenshots/github.png" />

minimo (video) is a free mobile app for shrinking videos directly on your device.
No cloud upload. No subscription. Your videos stay yours.

</div>


## Features

- Simple quality presets: high, medium, low
- Advanced controls: CRF, speed preset, resolution, frame rate, codec, audio
- Batch compression
- Progress screen with time estimate
- Save and share compressed videos
- Optional metadata preservation and album saving
- English and Russian localization

## Native compression pipeline

```mermaid
flowchart TD
    A[CompressBloc<br/>processes videos sequentially] --> B[VideoCompressorAdapter<br/>builds quality, resolution, codec and audio config]
    B --> C[v_video_compressor Dart API]
    C -->|MethodChannel: compressVideo| D{Native platform plugin}

    subgraph Android
        E[Media3 Transformer]
        E --> F[EditedMediaItem<br/>scale, rotate, trim and audio options]
        F --> G[MediaCodec<br/>H.264 or HEVC video + AAC audio]
        G --> H[Media3 MP4 output]
    end

    subgraph iOS
        I[AVURLAsset]
        I --> J[AVAssetExportSession<br/>native quality preset]
        J --> K[Optional AVMutableVideoComposition<br/>scale, rotate and frame rate]
        K --> L[System H.264 or HEVC + AAC codecs]
        L --> M[AVFoundation MP4 output]
    end

    D -->|Android| E
    D -->|iOS| I
    E -.->|EventChannel progress| A
    J -.->|EventChannel progress| A
    H --> N[Native result]
    M --> N
    N -->|MethodChannel result| O{Output is smaller?}
    O -->|Yes| P[Move MP4 to temporary output]
    O -->|No| Q[Discard result and keep original]
```

Compression uses native platform APIs, not FFmpeg. Input, output, and intermediate files stay on the device.

### Why not FFmpeg?

Media3 and AVFoundation keep the app smaller, use platform hardware acceleration, consume less battery, and avoid bundling another native runtime. They cover minimo's current goal: straightforward on-device video compression.

The trade-off is less low-level control and small output differences between Android and iOS. FFmpeg would make sense if the app needed identical cross-platform encoding, uncommon formats, or complex filter pipelines.

FFmpeg is available under LGPL or GPL depending on how it is built and which components are enabled. Shipping its binaries would require tracking that configuration and satisfying the corresponding redistribution, attribution, relinking, and source-code obligations. Using system Media3 and AVFoundation codecs avoids distributing FFmpeg and keeps the app itself under the MIT License. Codec patent and store requirements may still apply independently.

## How to contribute

[![Contributing](https://img.shields.io/badge/Contributing-Guide-414141?style=for-the-badge)](CONTRIBUTING.md) [![Code of Conduct](https://img.shields.io/badge/Code_of_Conduct-Rules-414141?style=for-the-badge)](CODE_OF_CONDUCT.md)

### Project support

[![Support - Stars](https://img.shields.io/badge/Support-Stars-414141?style=for-the-badge&logo=Telegram&logoColor=F1F1F1)](https://t.me/khlebobul_dev)


## Credits

Special thanks to [Kamran Bekirov](https://x.com/kamranbekirovyz) and his website [Flutter Pro Design](https://flutterpro.design/). I learned from and adapted many ideas from his work for myself and for this app.


## Contacts

[![@khlebobul](https://img.shields.io/badge/@khlebobul-414141?style=for-the-badge&logo=X&logoColor=F1F1F1)](https://x.com/khlebobul) [![Email - khlebobul@gmail.com](https://img.shields.io/badge/Email-khlebobul%40gmail.com-414141?style=for-the-badge&logo=Email&logoColor=F1F1F1)](mailto:khlebobul@gmail.com) [![@khlebobul_dev](https://img.shields.io/badge/%40khlebobul__dev-414141?style=for-the-badge&logo=Telegram&logoColor=F1F1F1)](https://t.me/khlebobul_dev) [![Personal - Website](https://img.shields.io/badge/Personal-Website-414141?style=for-the-badge&logo=Personal&logoColor=F1F1F1)](https://khlebobul.github.io/)

## License

[![LICENCE - MIT](https://img.shields.io/badge/LICENCE-MIT-414141?style=for-the-badge&logo=Licence&logoColor=F1F1F1)](https://github.com/minimo-pro/minimo_video/blob/main/LICENSE)
