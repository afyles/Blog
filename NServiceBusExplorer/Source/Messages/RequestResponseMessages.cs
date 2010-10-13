namespace Messages
{
    using System;
    using NServiceBus;

    public interface IRequestDataMessage : IMessage
    {
        Guid DataId { get; set; }
        String String { get; set; }
    }

    public interface IDataResponseMessage : IMessage
    {
        Guid DataId { get; set; }
        String String { get; set; }
    }

    public class SendRequestDataMessage : IMessage
    {
        
    }
}
