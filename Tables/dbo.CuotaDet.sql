CREATE TABLE [dbo].[CuotaDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_EC] [int] NOT NULL,
[Cd_Cuo] [int] NOT NULL,
[Item] [int] NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CuotaDet] ADD CONSTRAINT [PK_CuotaDet] PRIMARY KEY CLUSTERED  ([RucE], [Cd_EC], [Cd_Cuo], [Item]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CuotaDet] ADD CONSTRAINT [FK_CuotaDet_Cuota] FOREIGN KEY ([RucE], [Cd_EC], [Cd_Cuo]) REFERENCES [dbo].[Cuota] ([RucE], [Cd_EC], [Cd_Cuo]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001', 'SCHEMA', N'dbo', 'TABLE', N'CuotaDet', 'COLUMN', N'Cd_Srv'
GO
