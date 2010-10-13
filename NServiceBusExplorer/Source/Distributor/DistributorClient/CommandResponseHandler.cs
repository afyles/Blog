namespace DistributorClient
{
    using System;
    using Messages;
    using NServiceBus;

    class CommandResponseHandler //: IHandleMessages<ICommandResponse>
    {
        #region IMessageHandler<ICommandResponse> Members

        public void Handle(ICommandResponse message)
        {
            Console.WriteLine("Response from command {0} completed with success of {1}", message.CommandId, message.Success);
        }

        #endregion
    }
}
