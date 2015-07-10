# Scheduler before Service objects

This is an example of what happens when you are focused on deliver results and do not take pride in your work. This was a delivery from a freelancer that sadly enough had potential to become a good Ruby developer, but never fully understood the meaning of well-written code. After several attempt of introducing basic principles from "Practical Object-Oriented Design in Ruby" by Sandi Metz, I had to left the freelancer go.

Please take a look at Scheduler after Service Objects to see the differences and get an understanding why this is important to deliver quality and not just something works. Please don't get me wrong. It is, of course, important that the code works, but it is also important that code is easy to test and maintain.

Should you end up in similiar situation, I can recommend the following approach.

Step 1. Make sure that you full test coverage. Don't begin any refactory before you are absolutely sure that you know what you are changing and can verify that any change didn't break the existing code.

Step 2. Write a brief description to each method

Step 3. Use the description to give the methods meaningful names

Step 4. Introduce Special Case Object to handle nil case situations. See Ruby Tapas #112 for details

Step 5. Replace method with method object (class)

Step 6. Finally, introduce Service Object.

These guidelines, I would like to credit my good friend, Tute Costa. Please see his presentation https://www.youtube.com/watch?v=ozWzehOEeuI on refactoring.


