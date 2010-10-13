Const MQ_ERROR_QUEUE_EXISTS = -1072824317

set qinfo = CreateObject("MSMQ.MSMQQueueInfo")

' PUB SUB QUEUES
CreateQueue ".\private$\NServiceBus_error"
CreateQueue ".\private$\NServiceBus_messagebus"
CreateQueue ".\private$\NServiceBus_subscriptions"
CreateQueue ".\private$\NServiceBus_inbound"
CreateQueue ".\private$\NServiceBus_productarchive"
CreateQueue ".\private$\NServiceBus_worker"
CreateQueue ".\private$\NServiceBus_worker1"
CreateQueue ".\private$\NServiceBus_worker2"

' DISTRIBUTOR QUEUES
CreateQueue ".\private$\nservicebus_distributor_client"
CreateQueue ".\private$\nservicebus_distributor_control_bus"
CreateQueue ".\private$\nservicebus_distributor_data_bus"
CreateQueue ".\private$\nservicebus_distributor_storage"
CreateQueue ".\private$\nservicebus_distributor_worker1"


' SAGA QUEUES
' CreateQueue ".\private$\NServiceBus_timeoutmanager"

Sub DeleteQueue(queueName)
	On Error Resume Next
	qinfo.PathName = queueName
	qinfo.Delete
	If Err.Number <> MQ_ERROR_QUEUE_EXISTS And Err.Number <> 0 Then
		MsgBox "Error " & CStr(Err.Number) & ": " & Err.Description
		WScript.Quit
	End If
End Sub

Sub CreateQueue(queueName)
	DeleteQueue queueName
	qinfo.PathName = queueName
	qinfo.Create true
End Sub
