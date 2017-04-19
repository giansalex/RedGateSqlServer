CREATE TABLE [dbo].[DirecTrans]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Tra] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Item] [int] NOT NULL,
[Direc] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DirecTrans] ADD CONSTRAINT [PK_DirecTrans] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Tra], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DirecTrans] ADD CONSTRAINT [FK_DirecTrans_Transportista] FOREIGN KEY ([RucE], [Cd_Tra]) REFERENCES [dbo].[Transportista] ([RucE], [Cd_Tra])
GO
EXEC sp_addextendedproperty N'MS_Description', N'TRA0001', 'SCHEMA', N'dbo', 'TABLE', N'DirecTrans', 'COLUMN', N'Cd_Tra'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item x Ruc_Ctt', 'SCHEMA', N'dbo', 'TABLE', N'DirecTrans', 'COLUMN', N'Item'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observacion (Hrios, Reglas, Etc)', 'SCHEMA', N'dbo', 'TABLE', N'DirecTrans', 'COLUMN', N'obs'
GO
