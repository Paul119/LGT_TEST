CREATE VIEW [dbo].[Kernel_View_Payee_TransferRequest]
AS
SELECT
       N.*,
       NL.[idTree] AS [idTree],
       py.[firstname] +' '+ py.[lastname] AS [parentFullName],
       PY_OLD.[firstname] +' '+ PY_OLD.[lastname] AS [oldParentFullName],
       PY_EMP.[firstname] +' '+ PY_EMP.[lastname] As [employeeFullName],
       T.name AS [statusName]
       FROM [dbo].[hm_NodeTransfer] N WITH (NOLOCK)
       INNER JOIN [dbo].[hm_NodelinkPublished] AS NL WITH (NOLOCK) ON N.[id_hm_nodelink] = NL.[id]
       INNER JOIN [dbo].[py_Payee] AS PY WITH (NOLOCK) ON PY.[idPayee] = N.[idParent]
       INNER JOIN [dbo].[py_Payee] AS PY_OLD WITH (NOLOCK) ON PY_OLD.[idPayee] = N.[idOldParent]
       INNER JOIN [dbo].[py_payee] PY_EMP WITH (NOLOCK) ON PY_EMP.[idPayee] = N.[idEmployee] 
       INNER JOIN [dbo].[hm_TransferStatus] T WITH (NOLOCK) ON T.[id] = N.[idStatus]