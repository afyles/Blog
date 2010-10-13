namespace Worker1
{
    using NServiceBus;

    public class EndpointConfig : IConfigureThisEndpoint, AsA_Server, ISpecifyMessageHandlerOrdering
    {
        #region ISpecifyMessageHandlerOrdering Members

        public void SpecifyOrder(Order order)
        {
            order.Specify(First<CommandHandler>.Then<CommandHandler1>().AndThen<CommandHandler2>());
        }

        #endregion
    }
}
