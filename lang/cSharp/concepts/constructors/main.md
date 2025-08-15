# C Sharp Concepts - Constructors

## Abstract
In C#, **constructors** are special methods used to initialize objects of a class. There are several types of constructors, each serving different purposes. Here's a breakdown:

---

### 🧱 1. **Default Constructor**
- Takes no parameters.
- Automatically provided if no other constructors are defined.

```c sharp
public class Person {
    public Person() {
        // Initialization logic
    }
}
```

---

### 🧩 2. **Parameterized Constructor**
- Accepts parameters to initialize fields or properties.

```c sharp
public class Person {
    public string Name;
    public int Age;

    public Person(string name, int age) {
        Name = name;
        Age = age;
    }
}
```

---

### 🔁 3. **Copy Constructor**
- Creates a new object by copying an existing one.

```c sharp
public class Person {
    public string Name;
    public int Age;

    public Person(Person other) {
        Name = other.Name;
        Age = other.Age;
    }
}
```

---

### 🏗️ 4. **Static Constructor**
- Used to initialize static members of a class.
- Runs only once, before the first instance or static member is accessed.

```c sharp
public class Config {
    public static string AppName;

    static Config() {
        AppName = "MyApp";
    }
}
```

---

### 🧬 5. **Private Constructor**
- Prevents instantiation from outside the class.
- Often used in **singleton patterns**.

```c sharp
public class Singleton {
    private static Singleton instance;

    private Singleton() { }

    public static Singleton GetInstance() {
        if (instance == null)
            instance = new Singleton();
        return instance;
    }
}
```

---

### 🧠 6. **Constructor Overloading**
- Multiple constructors with different parameter lists.

```c sharp
public class Person {
    public string Name;
    public int Age;

    public Person() { }

    public Person(string name) {
        Name = name;
    }

    public Person(string name, int age) {
        Name = name;
        Age = age;
    }
}
```

---

Would you like help designing constructors for a specific class or pattern (like Singleton or Factory)?

## Directory

## Useful Links

## Tags
[[c-sharp-concepts]]
