namespace Server
{
    using System;
    using Messages;
    using Server.Core;

    public class ProductChangedHandler : UnitOfWorkMessageHandler<IProductCreatedEvent>
    {
        public ProductChangedHandler(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        public override void HandleMessage(IProductCreatedEvent message)
        {
            NHibernateUnitOfWork uow = base.CurrentUnitOfWork as NHibernateUnitOfWork;

            if (null != uow)
            {
                using (var session = uow.SessionFactory.GetCurrentSession())
                {
                    // do what you need to do with the session
                    Department d = new Department { Id = 4, GroupName = "NSERVICBUS", Name = "NH", ModifiedDate = DateTime.Now };

                    session.Save(d);

                }
            }
        }
    }
}
