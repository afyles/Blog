namespace Client
{
    using System;
    using NServiceBus;
    using Messages;

    public class ResponseHandler : IHandleMessages<IDataResponseMessage>
    {
        public void Handle(IDataResponseMessage message)
        {
            Console.WriteLine("Response received with description: {0}", message.String);
        }
    }
}
