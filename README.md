
## **Monitor Analyst Checkout and Transactions Test**

🎯 This repository contains a Ruby on Rails application that provides solutions to the tasks of the Monitor Analyst Checkout and Transactions Test. The application is designed to test the candidate's understanding of the payments industry and their ability to analyze data using SQL.

#### **🔧 Prerequisites:**
Before running the application, you must have the following installed:

- Ruby 3.1.2p20
- Rails 7.0.6
- PostgreSQL

#### **🔧 Installation:**
To run the application on your machine, perform the following steps:

1. Make a folder to clone the project:
mkdir name_of_the_folder / cd into it
2. Clone the repository:
git clone git@github.com:RonMon80/analyze.git
3. Change to the repository directory:
cd name_of_the_folder/analyze
4. Install the required gems:
bundle install && yarn install
5. Create the database:
rails db:create
6. Run the database migrations:
rails db:migrate
7. Start the application:
rails server or bin/dev

8. Open your web browser and navigate to http://localhost:3000 to view the application.

9. The CSV files to allow the test are in the root folder, to be copied outside the app, to be browsed.

#### **🔧 Results:**
The application provides solutions to the tasks of the Monitor Analyst Checkout and Transactions Test, including:

- At Checkout Analisis:
- Charts graphs that show the analisis of anomalies, in 24h time, counting: today, yesterday, same day last week, avg_last_week, avg_last_month
- At Transactions Analisis:
- Charts graphs that show the analisis of anomalies, in 24h time, counting: time, status and number counting.

The results are displayed in an easy-to-read Charts.
