{
  "name": "SQMessages",
  "version": "0.0.1",
  "summary": "Easy to use and customizable messages/notifications for iOS .",
  "description": "                    Base TSMessages; This framework provides an easy to use class to show little notification views on the top of the screen. \nThere are 4 different types already set up for you: Success, Error, Warning, Message.\n",
  "homepage": "https://github.com/KrauseFx/SQMessages/",
  "license": "MIT",
  "authors": {
    "Felix Krause": "semny.qu@gmail.com"
  },
  "source": {
    "git": "https://github.com/semnyqu/SQMessages.git",
    "tag": "0.0.1"
  },
  "platforms": {
    "ios": "6.0"
  },
  "requires_arc": true,
  "source_files": "Pod/Classes",
  "resources": [
    "Pod/Assets/*.png",
    "Pod/Assets/*.json"
  ],
  "public_header_files": "Pod/Classes/**/*.h",
  "dependencies": {
    "HexColors": [
        "~> 2.3.0"
    ],
    "Masonry":[
	"~> 1.1.0"
    ],
    "MarqueeLabel":[
	"~> 3.1.3"
    ],
    "NSHash":[
	"~> 1.2.0"
    ]
  }
}
