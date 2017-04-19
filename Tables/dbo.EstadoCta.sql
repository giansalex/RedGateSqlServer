CREATE TABLE [dbo].[EstadoCta]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_EC] [int] NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ReglasMoras] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[ReglasPorc] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoCta] ADD CONSTRAINT [PK_EstadoCta] PRIMARY KEY CLUSTERED  ([RucE], [Cd_EC]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'EstadoCta', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'EstadoCta', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'EstadoCta', 'COLUMN', N'Cd_SS'
GO
