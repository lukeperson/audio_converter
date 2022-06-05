# Setup

## Install dependencies

Install brew https://brew.sh/
```
brew install ffmpeg
brew install sox
```

## Create necessary folders
```
# Temp storage before they are converted to audio, can check text here
mkdir ~/txt

# Script backs up all epubs in this folder
mkdir ~/Epubs

# Where any image files in epub are stored
mkdir ~/images

# Where the script stores the audio files
mkdir ~/Audio
```

# Running the scripts
```
touch ~/Downloads/<name of epub>
./convertEpubToText.sh
```

The first param will be the reading rate in words per minute
```
./batch_convert_txt_to_audio.sh 400
```


