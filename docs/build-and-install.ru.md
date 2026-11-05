# Сборка и подключение

## Проверенное окружение

Windows x64, Statistica 14.0.0.15, MSBuild 18.11.1, MSVC v141 14.16.27023, Windows SDK 10.0.26100.0, Boost 1.60, MKLML 2018.0.3.20180406, Protobuf 3.1.0, MS-MPI SDK и Runtime. Python 3.14.3 использовался для подготовки данных, а не как binding CNTK.

## Подготовка

1. Получить CNTK v2.7 и закреплённые подмодули Multiverso, GSL, ONNX и ONNX Runtime. Не заменять их последними ветками.
2. Установить toolchain v141, SDK, CMake, MPI SDK и Runtime. Bootstrapper VS сам по себе не является offline-установщиком.
3. Собрать Boost x64 Release static с runtime-link=shared. См. project-config и команды в кейсе; обозначение msvc-14.0 использовано для старого Boost.Build при фактическом компиляторе v141.
4. Подготовить MKLML с include и lib (mklml.lib, mklml.dll, libiomp5md.dll). NuGet CNTK.Deps.MKL содержит runtime, но не полноценный SDK.
5. Скопировать содержимое recipes в отдельную рабочую папку. Положить исходники protobuf-3.1.0 и распакованный MKLML в её deps. Проверить и отредактировать пути в скриптах.

## Порядок

Common была собрана отдельно из Source/Common/Common.vcxproj с Release_CpuOnly/x64/v141 и SolutionDir. Её Cntk.Common-2.7.lib нужно поместить в рабочий build/out. Скрипта Common в этом архиве рецептов пока нет.

Далее из обычного PowerShell: build-math, build-profiler, build-network, build-sequence, build-sgd, build-actions. Выполнить build-protobuf.cmd, затем build-reader, build-core, build-cntk, build-textreader. Останавливаться на первой ошибке и проверять выходной артефакт; условная цель Core без Protobuf может вернуть 0 без сборки.

Во всех .ps1 используется отдельный IntDir и общий build/out. workspace-link.targets добавляет OutDir к путям линковки. Установленные компоненты и архивы следует сохранять отдельно с SHA-256; путь и состав offline-тома из истории кейса относятся к исходной машине и не поставляются здесь.

## NDL и структура установки

Файлы исходников CNTK:
- Tests/EndToEndTests/Examples/Image/Deprecated/MNIST/Macros.ndl
- Tests/EndToEndTests/Examples/Image/Deprecated/MNIST/02_Convolution_ndl/02_Convolution.ndl

Ожидаемая структура Statistica:

```text
Statistica/
  cntk/
    cntk/
      CNTK.exe
      CNTK.core.bs
      Cntk.Core-2.7.dll
      Cntk.Math-2.7.dll
      Cntk.PerformanceProfiler-2.7.dll
      Cntk.Deserializers.TextFormat-2.7.dll
      mklml.dll
      libiomp5md.dll
    Examples/Image/MNIST/Config/
      Macros.ndl
      02_Convolution.ndl
```

В обоих узлах CNTK Language поставить deviceId=-1. Для обучения начать с maxEpochs=1 и постоянного Root directory. Параметры с фигурными скобками подставляет C#; в исходном Deployment RootDirectoryPath не заменялся, но используемые modelPath/DataFile/outputPath задавались отдельно.

## Проверка

Сначала CLI без аргументов (справка; код 1 допустим только для этой проверки), затем короткое обучение, затем запуск из Statistica. Проверить появление Model, выполнить Deployment и экспортировать CSV: 10 000 строк, классы 0–9, вероятности конечны и в [0,1], сумма около 1, Predicted совпадает с argmax. Сверить ошибки таблицы с errs движка. Точное качество повторного обучения не гарантируется.
