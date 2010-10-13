namespace Server
{
    using System;
    using Messages;
    using NServiceBus;
    using NHibernate;
    using Server.Core;

    public class ProductCreatedHandler : IHandleMessages<IProductCreatedEvent>
    {
        private readonly ISessionFactory internalFactory;

        public ProductCreatedHandler(ISessionFactory factory, IBus bus)
        {
            this.internalFactory = factory;
            this.Bus = bus;
        }

        public IBus Bus { get; set; }

        public void Handle(IProductCreatedEvent message)
        {
            using (var session = this.internalFactory.GetCurrentSession())
            {
                using (var transaction = session.BeginTransaction())
                {
                    // do what you need to do with the session
                    Department d = new Department { Id = 3, GroupName = "NSERVICBUS", Name = "NH", ModifiedDate = DateTime.Now };

                    session.Save(d);

                    transaction.Commit();
                }
            }
        }
    }
}
