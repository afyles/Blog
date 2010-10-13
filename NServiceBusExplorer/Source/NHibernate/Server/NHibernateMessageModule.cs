namespace Server
{
    using System;
    using NServiceBus;
    using NHibernate;
    using NHibernate.Context;


    public class NHibernateMessageModule : IMessageModule
    {
        private readonly ISessionFactory internalFactory;

        public NHibernateMessageModule(ISessionFactory factory)
        {
            this.internalFactory = factory;
        }

        public void HandleBeginMessage()
        {
            CurrentSessionContext.Bind(this.internalFactory.OpenSession());
        }

        public void HandleEndMessage()
        {
            CurrentSessionContext.Unbind(this.internalFactory);
        }

        public void HandleError()
        {
        }
    }
}
