namespace WcfServer
{
    using Messages;
    using NServiceBus;

    public class ProductCreatedService : WcfService<ProductCreatedMessage,CommandErrorCodes>
    {
    }
}
