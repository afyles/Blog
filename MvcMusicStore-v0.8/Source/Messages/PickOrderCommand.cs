using System;

namespace Messages
{
    public interface IPickOrderCommand : ICommand
    {
        Int32 OrderId { get; set; }
    }
}
