#set page(paper: "a4", numbering: "1")
#set text(size: 14pt, font: "Arial")
#set heading(numbering: "1.1.")

#align(center, text(20pt, weight: "semibold")[
  SOFTWARE REQUIREMENTS SPECIFICATIONS \
  FOR \
  CHEATSHIELD
])

#v(2cm)

#align(center, text(16pt)[
  Al Azhar Rizqi Rifai Firdaus - 2241720002 \
  Dicha Zelianivan Arkana - 2241720002 \
  Muhammad Baihaqi Aulia Asy'ari - 2241720002 \ \
  #datetime.today().display("[day] [month repr:long] [year]")
])

#v(2cm)

#align(center, image("./polinema-logo.png", width: 5cm))

#v(2cm)

#align(center, text(16pt)[
  D-IV INFORMATICS ENGINEERING \
  INFORMATION TECHNOLOGY DEPARTMENT \
  STATE POLYTECHNIC OF MALANG
])

#pagebreak()

#outline(
  title: "Table of Contents",
  indent: true,
)

#pagebreak()

= Preface

== Purpose of the document

This document has a purpose to provide a high-level overview of the software development requirements
used in the process of developing Cheatshield. Every requirement is described in detail, including
the purpose, the scope or limitation, the specification, and the implementation.

== Target audience and recommended readers

The target audience for this document is outlined below:

+ *The developers*: Software developers who are responsible for the development of the software.
+ *The testers*: Software testers who are responsible for testing the software.
+ *The users*: End-users who are responsible for using the software.

== Product Limitation

The software developed for Cheatshield has several limitations, which are outlined below:

+ The software is designed to be used on a mobile device.
+ The software doesn't guarantee 100% of accuracy, but it will try to provide the best possible results.
+ The software will only provide simple quiz functionality since the focus of the software
  is to provide a mechanism to prevent cheating in exams.

== Definitions and Acronyms

The following definitions and acronyms are used in this document:

- *Cheatshield*: The software developed for the purpose of preventing cheating in exams.
- *Cheating*: The act of intentionally providing incorrect answers to questions in an exam.
- *Quiz*: A test or exam that requires the participant to answer a series of questions.
- *Question*: A question asked in a quiz. Each quiz can have multiple questions.
- *Option*: An option provided to a participant in a question.
- *Answer*: The correct answer to a question.
- *Correct answer*: The correct answer to a question.
- *Incorrect answer*: An incorrect answer to a question.
- *Accuracy*: The percentage of correct answers provided by a participant.
- *Accuracy threshold*: The minimum percentage of correct answers required to pass a quiz.
- *Face Recognition*: The process of identifying the person who is providing the answer to a question.
- *API*: Application Programming Interface.
- *SDK*: Software Development Kit.
- *Flutter*: A mobile application development framework.
- *Laravel*: A PHP web application framework.
- *PostgreSQL*: A relational database management system.
- *Filament*: A meta-framework for building web applications built on top of Laravel.
- *Docker*: A containerization platform.

== References

This section is TBD

= Overview
== Product description

*Cheatshield* is a software developed for the purpose of preventing cheating in exams. The software
consists of 3 parts, which can be summarized as follows:

+ *Mobile Application*:
  An application developed using the Flutter framework that provides a user-friendly interface for
  users to take quizzes. When a user takes a quiz, the application will use the Face Recognition
  API to identify the person who is providing the answer to a question. If there is no face detected,
  there are several conditions that could happen:
    - If the user hasn't started the quiz, the application will display a message indicating that
      the user should configure their camera to capture their face when taking the quiz.
    - If the user has started the quiz and the detected face suddenly disappears, the application
      will show a warning message indicating that the user have a possibility of cheating.
    - If the user has started the quiz and the Face Recognition detects a suspicious movement of
      the face, the application will show a warning message indicating that the user have a
      possibility of cheating.
+ *Web Application*:
  A web application developed using the Filament framework that provides a user-friendly interface
  for the admins to manage quizzes, users, etc. The application will provide an interface to create
  and start a quiz session. When a user takes a quiz, the application will be able to see who is
  currently taking the quiz, the current question of the said user, and the status if the user
  has a potential of cheating.
+ *Face Recognition API*:
  An API using Convolutional Neural Networks (CNN) to detect the face of a person. The API will
  be able to detect the face of a person in real-time and provide the information to the mobile
  application.

== Product functions

The product functions are outlined below:

+ *Quiz taking*: The mobile application will allow users to take quizzes.
+ *Quiz management*: The web application will allow the admins to manage quizzes, users, etc.
+ *Face recognition*: The Face Recognition API will be able to detect the face of a person in real-time.
+ *Face recognition monitoring*: The Face Recognition API will be able to detect the face of a person in real-time to detect if they're cheating or not.

== User groups

The user groups are outlined below:

+ *Student*: Students who are taking quizzes.
+ *Admin*: Admins who are responsible for managing quizzes, users, etc.
+ *Developer*: Developers who are responsible for the development of the software.
+ *Tester*: Testers who are responsible for testing the software.

== Operating environment

The operating environment for each part of the application is outlined below:

- *Mobile application*: Android and iOS.
- *Web application*:
  - *Laravel / Filament*: Linux server inside a container managed by Docker.
  - *PostgreSQL*: Linux server inside a container managed by Docker.
- *Face Recognition API*: Linux server inside a container managed by Docker.

== Design limitations and implementation

The design limitations and implementation are outlined below:

- *Mobile application*: The mobile application will be developed using the Flutter framework.
- *Web application*: The web application will be developed using Laravel and Filament frameworks using PostgreSQL as the database.
- *Face Recognition API*: The Face Recognition API will be developed using the FaceNet library.
- *Docker*: The Docker containers will be deployed an orchestrated using Docker Compose.

== User Documentation

= External interfaces requirements
== User interface
== Hardware interface

The hardware interface requirements are outlined below:

- *Camera*: The mobile application will use the camera to capture the user's face. The camera should be good enough
  to capture the user's face clear enough.
- *Android / iOS*: The device should be able to run the mobile application. Since it is

== Software interface
== Communication interface

= Functional requirements
== Use-case diagrams

= Non-functional requirements
