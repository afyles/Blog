namespace Messages
{
    using System;

    public interface IProductChangedEvent : IEvent
    {
        Int32 ProductNumber { get; set; }
        String Name { get; set; }
        String Description { get; set; }       
    }
}
