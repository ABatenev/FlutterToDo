using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ToDoBackend.Models;

namespace ToDoBackend.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ToDoController : ControllerBase
    {
        private readonly ILogger<ToDoController> Logger;
        
        private ToDoContext Context;

        public ToDoController(ILogger<ToDoController> logger, ToDoContext context)
        {
            this.Logger = logger;
            this.Context = context;
        }

        [HttpGet]
        public IEnumerable<ToDo> Get()
            => this.Context
                   .ToDos
                   .ToList()
                   .OrderBy(x => x.CreatedAt);

        [HttpPost]
        public void Post([FromBody] string name)
        {
            var todo = new ToDo()
            {
                Name       = name,
                CreatedAt  = DateTime.UtcNow,
                IsComplete = false
            };

            this.Context.ToDos.Add(todo);
            this.Context.SaveChanges();
        }

        [HttpPatch("{id}")]
        public void Post(int id)
        {
            var todo = this.Context.ToDos.Find(id);

            todo.IsComplete = true;

            this.Context.ToDos.Update(todo);
            this.Context.SaveChanges();
        }

        [HttpDelete("{id}")]
        public void Delete(int id)
        {
            var todo = this.Context.ToDos.Find(id);

            this.Context.ToDos.Remove(todo);
            this.Context.SaveChanges();
        }
    }
}