namespace ToDoBackend.Models
{
    public class ToDo
    {
        public int Id { get; set; }
        
        public string Name { get; set; } = null!;
        
        public DateTime CreatedAt { get; set; }
        
        public bool IsComplete { get; set; }
    }
}