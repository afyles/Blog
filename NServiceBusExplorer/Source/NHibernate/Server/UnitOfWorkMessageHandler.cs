namespace Server
{
    using System;
    using NServiceBus;

    /// <summary>
    /// 
    /// </summary>
    /// <see cref="http://www.erata.net/net/nservicebus-with-nhibernate-and-mysql/"/>
    /// <typeparam name="T"></typeparam>
    public abstract class UnitOfWorkMessageHandler<T> : IMessageHandler<T> where T : IMessage
    {
        private readonly IUnitOfWork internalUnitOfWork;

        public UnitOfWorkMessageHandler(IUnitOfWork unitOfWork)
        {
            this.internalUnitOfWork = unitOfWork;
        }

        public IUnitOfWork CurrentUnitOfWork { get { return this.internalUnitOfWork; } }

        public abstract void HandleMessage(T message );

        public void Handle(T message)
        {
            try
            {
                this.internalUnitOfWork.Enlist();
                this.HandleMessage(message);
                this.internalUnitOfWork.Complete();
            }
            catch
            {
                this.internalUnitOfWork.Rollback();
                throw;
            }
            finally
            {
                //  disposes transaction & session, unbinds context
                this.internalUnitOfWork.Dispose();
            }
        }
    }
}
