using System.Diagnostics;
using ToDoBackend.Models;

namespace ToDoBackend
{
    public static class DbInitializer
    {
        public static void Initialize(ToDoContext context)
        {
            context.Database.EnsureCreated();

            // Look for any students.
            if (context.ToDos.Any())
            {
                return;   // DB has been seeded
            }

            var todos = new ToDo[]
            {
                new ToDo() { Name = "Сходить на пары", CreatedAt = DateTime.Now, IsComplete = false },
                new ToDo() { Name = "Сделать дз", CreatedAt = DateTime.Now, IsComplete = false },
                new ToDo() { Name = "Поиграть майнкрафт", CreatedAt = DateTime.Now, IsComplete = false },
                new ToDo() { Name = "Покормить кекса", CreatedAt = DateTime.Now, IsComplete = false },
                new ToDo() { Name = "Выпить пива", CreatedAt = DateTime.Now, IsComplete = false },
            };
            foreach (var todo in todos)
            {
                context.ToDos.Add(todo);
            }
            context.SaveChanges();
        }
    }
}
