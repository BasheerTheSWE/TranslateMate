# iOS Language Translator Application
#### TranslateMate

<img width="1317" alt="Screenshot 2023-09-28 at 5 31 16 PM" src="https://github.com/basheer-dev/TranslateMate/assets/135429870/8e88f6ab-a1f7-4132-8e21-e2c098ff15cb">


- This iOS application allows users to translate text into different languages using :
	1. Voice input. 
	2. Manual text input. 

The app offers two main tabs: one for voice translation and another for manual text translation. It utilizes Core Data for storing translations, a translation rapid API for language translation, the Speech framework for voice input, AVFoundation for speech output, and UIKit for the user interface.



## Features

### Voice Translation
- Users can select a target language and use the record button to input text through voice.
- The application extracts text from the user's voice and sends it for translation using the translation API.
- The translated text is displayed to the user.
  
![Simulator Screen Recording - iPhone 14 Pro - 2023-09-28 at 17 33 25](https://github.com/basheer-dev/TranslateMate/assets/135429870/aeaf8684-180e-4a10-9718-be488ab3c1a9)



### Text Translation
- Users can select a target language and input text manually by typing into a text view.
- The application translates the input text using the translation API and displays the translated text to the user.
  
![Simulator Screen Recording - iPhone 14 Pro - 2023-09-28 at 17 33 09](https://github.com/basheer-dev/TranslateMate/assets/135429870/3c965673-db74-4917-b6d0-9e77228da9f1)



### Translation History
- The app maintains a translation history that displays all previous translations performed by the user.
- Users can clear the translation history using the "Clear History" button.
  
![Simulator Screen Recording - iPhone 14 Pro - 2023-09-28 at 17 32 36](https://github.com/basheer-dev/TranslateMate/assets/135429870/b433b12d-7446-4169-8542-f3e61c4849a0)




## Libraries and APIs

- **Core Data**: Utilized for storing translation history.
- **MyMemory - Translation Memory API**: Utilized for language translation. [MM-TM API](https://rapidapi.com/translated/api/mymemory-translation-memory).
- **Speech Framework**: Used to extract text from voice input and for speech output.
- **AVFoundation**: Utilized for speech output.
- **UIKit**: Used to build the user interface.



## Getting Started

To run this application on your iOS device or simulator, follow these steps:
1. Open the project in Xcode.
2. Set up the necessary dependencies and [API keys](https://rapidapi.com/translated/api/mymemory-translation-memory) in the `TranslateMate/Managers/APIManager.swift` file.
3. Build and run the application on your iOS device or simulator.



## Contributions

Contributions to improve and enhance the application are welcome. Feel free to create pull requests or open issues.



## License

This project is licensed under the **MIT License**. Feel free to use, modify, and distribute the code for your own purposes.


## Developer

If you wish to contact with me directly and talk about this project you're more than welcome to do so.

#### Contact

My name is **Basheer Abdulmalik** and you can find me here 👇
* [Twitter](https://twitter.com/basheer_dev) $\implies$ @Basheer_Dev.
* [Linkedin](https://www.linkedin.com/in/basheer-abdulmalik) $\implies$ @basheer-abdulmalik.
