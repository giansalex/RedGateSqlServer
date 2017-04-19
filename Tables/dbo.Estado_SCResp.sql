CREATE TABLE [dbo].[Estado_SCResp]
(
[Id_EstSCResp] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Activo] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Estado_SCResp] ADD CONSTRAINT [PK_Estado_SCResp] PRIMARY KEY CLUSTERED  ([Id_EstSCResp]) ON [PRIMARY]
GO
