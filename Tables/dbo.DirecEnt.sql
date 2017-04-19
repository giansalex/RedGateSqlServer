CREATE TABLE [dbo].[DirecEnt]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Direc] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL,
[PorDefecto] [bit] NULL CONSTRAINT [DF__DirecEnt__PorDef__7E4906A6] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DirecEnt] ADD CONSTRAINT [PK_DirecEnt] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Clt], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DirecEnt] WITH NOCHECK ADD CONSTRAINT [FK_DirecEnt_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item x Ruc_Ctt', 'SCHEMA', N'dbo', 'TABLE', N'DirecEnt', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observacion (Hrios, Reglas, Etc)', 'SCHEMA', N'dbo', 'TABLE', N'DirecEnt', 'COLUMN', N'obs'
GO
