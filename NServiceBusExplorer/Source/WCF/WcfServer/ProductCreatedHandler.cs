namespace WcfServer
{
    using System;
    using NServiceBus;
    using Messages;

    public class ProductCreatedHandler : IHandleMessages<ProductCreatedMessage>
    {
        public IBus Bus { get; set; }

        #region IMessageHandler<ProductCreatedMessage> Members

        public void Handle(ProductCreatedMessage message)
        {
            // Normally you would do a Bus.Send here first
            if (message.ProductNumber == 1111)
                this.Bus.Return((Int32)CommandErrorCodes.Fail);
            else
                this.Bus.Return((Int32)CommandErrorCodes.Success);
        }

        #endregion
    }
}
