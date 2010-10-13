namespace Messages.New
{
    using System;

    public interface IProductUpdatedEvent : Messages.IProductUpdatedEvent
    {
        Int32 DepartmentNumber { get; set; }
    }
}
