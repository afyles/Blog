namespace Server
{
    using System;
    using NHibernate;
    using NHibernate.Context;

    public class NHibernateUnitOfWork : IUnitOfWork
    {
        private readonly ISessionFactory internalSessionFactory;
        private ISession currentSession;
        private ITransaction currentTransaction;

        public NHibernateUnitOfWork(ISessionFactory factory)
        {
            this.internalSessionFactory = factory;
        }

        public ISessionFactory SessionFactory { get { return this.internalSessionFactory; } }

        public void Enlist()
        {
            this.currentSession = this.internalSessionFactory.OpenSession();
            CurrentSessionContext.Bind(this.currentSession);
            this.currentTransaction = this.currentSession.BeginTransaction();
        }

        public void Complete()
        {
            this.currentTransaction.Commit();
        }

        public void Rollback()
        {
            this.currentTransaction.Rollback();
        }

        public void Dispose()
        {
            this.currentTransaction.Dispose();
            CurrentSessionContext.Unbind(this.internalSessionFactory);
            this.currentSession.Dispose();
            GC.SuppressFinalize(this);
        }
    }
}
