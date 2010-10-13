namespace Fixtures.Mocks
{
    using System;
    using NServiceBus;

    public interface IOrderAcceptedEvent : IMessage
    {
        Guid Id { get; set; }
        String Text { get; set; }
    }
}
