1. Simple Calculator

```csharp
using System;

class Program
{
    static void Main()
    {
        Console.Write("Enter first number: ");
        int a = int.Parse(Console.ReadLine());

        Console.Write("Enter second number: ");
        int b = int.Parse(Console.ReadLine());

        Console.WriteLine("Sum: " + (a + b));
        Console.WriteLine("Difference: " + (a - b));
        Console.WriteLine("Product: " + (a * b));
        Console.WriteLine("Division: " + (a / b));
    }
}
```
```bash
-- Output --

Enter first number: 2
Enter second number: 3
Sum: 5
Difference: -1
Product: 6
Division: 0
```

---

2. Even Or Odd

```csharp

using System;

class Program
{
    static void Main()
    {
        Console.Write("Enter a number: ");
        int n = int.Parse(Console.ReadLine());
        Console.WriteLine(n % 2 == 0 ? "Even" : "Odd");
    }
}
```


```
-- Output --
Enter a number: 3
Odd
```

---

3. Grader 

```csharp

using System;
class Program
{
    static void Main()
    {
        Console.Write("Enter marks (0-100): ");
        int m = int.Parse(Console.ReadLine());

        if (m >= 90) Console.WriteLine("A");
        else if (m >= 75) Console.WriteLine("B");
        else if (m >= 50) Console.WriteLine("C");
        else Console.WriteLine("F");
    }
}
```
```
--- Output --- 
Enter marks (0-100): 69
C
```

4.  Day of the week

```csharp
using System;

class Program
{
    static void Main()
    {
        Console.Write("Enter number (1-7): ");
        int d = int.Parse(Console.ReadLine());

        switch (d)
        {
            case 1: Console.WriteLine("Sunday"); break;
            case 2: Console.WriteLine("Monday"); break;
            case 3: Console.WriteLine("Tuesday"); break;
            case 4: Console.WriteLine("Wednesday"); break;
            case 5: Console.WriteLine("Thursday"); break;
            case 6: Console.WriteLine("Friday"); break;
            case 7: Console.WriteLine("Saturday"); break;
            default: Console.WriteLine("Invalid"); break;
        }
    }
}
```

```
--- Output ---

Enter number (1-7): 5
Thursday
```

---

5. Factorial


```

using System;

class Program
{
    static void Main()
    {
        Console.Write("Enter number: ");
        int n = int.Parse(Console.ReadLine());
        int fact = 1;

        for (int i = 1; i <= n; i++)
            fact *= i;

        Console.WriteLine("fact: " + fact);
    }
}
```
```
--- Output ---

Enter number: 
fact: 120
```
---

6. Reverse a string

```csharp
using System;
class Program{
    static void Main(){
        string s=Console.ReadLine();
        for(int i=s.Length-1;i>=0;i--) Console.Write(s[i]);
    }
}
```
```
--- Output ---

racecar
racecar
```

---

7. Prime Number Method – Write a method IsPrime(int n) that returns true if the number is prime


```csharp

using System;

class Program
{
    static void Main()
    {
        Console.Write("Enter a number: ");
        int n = int.Parse(Console.ReadLine());
        Console.WriteLine(IsPrime(n) ? "Prime" : "Not Prime");
    }

    static bool IsPrime(int n)
    {
        if (n < 2) return false;
        for (int i = 2; i * i <= n; i++)
            if (n % i == 0) return false;
        return true;
    }
}
```

```
--- Output ---

Enter a number: 69
Not Prime
```

---

8. Check Palindrome

```csharp

using System;

class Program
{
    static void Main()
    {
        Console.Write("Enter a string or number: ");
        string input = Console.ReadLine();
        Console.WriteLine(IsPalindrome(input) ? "Palindrome" : "Not Palindrome");
    }

    static bool IsPalindrome(string s)
    {
        for (int i = 0, j = s.Length - 1; i < j; i++, j--)
            if (s[i] != s[j])
                return false;
        return true;
    }
}
```

```
--- Output ---

Enter a string or number: racecar
Palindrome
```

---

9. Student Class – Create a Student class with properties Name, Age, Grade and a method DisplayInfo(). 

```csharp
using System;

class Student
{
    public string Name { get; set; }
    public int Age { get; set; }
    public string Grade { get; set; }

    public void DisplayInfo()
    {
        Console.WriteLine($"Name: {Name}, Age: {Age}, Grade: {Grade}");
    }
}

class Program
{
    static void Main()
    {
        Student s = new Student { Name = "Alice", Age = 20, Grade = "A" };
        s.DisplayInfo();
    }
}
```


```
--- Output ---

Name: Alice, Age: 20, Grade: A
```

---

10.  Bank Account Class – Create a BankAccount class with methods Deposit, Withdraw, and CheckBalance(). 

```csharp
using System;

class BankAccount
{
    private decimal balance;

    public BankAccount(decimal initialBalance = 0)
    {
        balance = initialBalance;
    }

    public void Deposit(decimal amount)
    {
        if (amount > 0)
            balance += amount;
    }

    public bool Withdraw(decimal amount)
    {
        if (amount > 0 && amount <= balance)
        {
            balance -= amount;
            return true;
        }
        return false;
    }

    public decimal CheckBalance()
    {
        return balance;
    }
}

class Program
{
    static void Main()
    {
        BankAccount account = new BankAccount(1000);
        account.Deposit(500);
        bool success = account.Withdraw(200);
        Console.WriteLine(success ? "Withdrawal successful" : "Withdrawal failed");
        Console.WriteLine("Current Balance: " + account.CheckBalance());
    }
}
```
```
--- Output ---

Withdrawal successful
Current Balance: 1300
```
